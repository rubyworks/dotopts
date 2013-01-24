module DotOpts

  class Parser
    require 'shellwords'

    #
    RE_PROFILE_HEADER = /^\[/

    #
    RE_COMMAND_HEADER = /^\w/


    #
    def self.parse(text)
      parser = new(text)
      parser.parse
      parser
    end

    #
    def initialize(text)
      @text = text
      @arguments = []
    end

    #
    attr :text

    #
    attr :arguments

    #
    def parse
      lines = @text.lines.to_a
      if lines.first !~ RE_PROFILE_HEADER
        index = lines.index{ |line| line =~ RE_PROFILE_HEADER }
        if index
          lines = lines[index..-1] + ['[]'] + lines[0...index]
        else
          lines = ['[]'] + lines
        end
      end
      parse_profiles(lines)
    end

    #
    def parse_profiles(lines)
      while line = lines.shift
        line = line.strip
        if md = RE_PROFILE_HEADER.match(line)
          profile = md.post_match.chomp(']')
          case profile
          when /=/
            name, value = profile.split('=')
            if ENV[name] == value
              parse_commands(lines)
            end
          else
            if profile == (ENV['profile'] || ENV['p']).to_s
              parse_commands(lines)
            end
          end
        end
        #lines.shift
      end
    end

    #
    def parse_commands(lines)
      lines.shift while RE_PROFILE_HEADER =~ lines.first
      while line = lines.first
        line = line.strip
        if md = RE_COMMAND_HEADER.match(line)
          if current_command == line
            parse_arguments(lines)
          end
        elsif RE_PROFILE_HEADER.match(line)
          return lines
        end
        lines.shift
      end
    end

    #
    def parse_arguments(lines)
      lines.shift while RE_COMMAND_HEADER =~ lines.first
      parse_environment(lines)
      while line = lines.first
        break if RE_PROFILE_HEADER =~ line
        break if RE_COMMAND_HEADER =~ line
        line = line.strip
        @arguments << subenv(line) unless line.empty?
        lines.shift
      end
    end

    #
    def parse_environment(lines)
      while line = lines.first
        break unless line.strip.start_with?('$ ')
        name, value = line.strip.sub(/\$\s+/, '').split('=')  # TODO: handle quotes
        @environment[name] = subenv(value) unless name.empty?
        lines.shift
      end
    end

    #
    # @todo Note sure the cmd environment variable override is a good idea.
    #
    def current_command
      ENV['cmd'] || File.basename($0)
    end

    # Substitute environment variables.
    #
    # @return [String]
    def subenv(value)
      value.gsub(/\$(\w+)/){ |m| ENV[$1] }
    end

  end

end
