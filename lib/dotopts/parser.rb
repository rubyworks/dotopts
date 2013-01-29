module DotOpts

  class Parser
    require 'shellwords'

    #
    RE_PROFILE_HEADER = /^\[/

    #
    RE_COMMAND_HEADER = /^\w/

    #
    RE_BLANK_STRING = /^\s*$/

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
      @environment = {}
    end

    #
    attr :text

    #
    attr :arguments

    #
    attr :environment

    #
    def parse
      lines = @text.lines.to_a

      remove_initial_blank_lines(lines)

      # put initial non-profiled settings last 
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
      until lines.empty?
        line = lines.first.rstrip
        if md = RE_PROFILE_HEADER.match(line)
          profile = md.post_match.chomp(']')
          matches = shellwords(profile).all? do |shellword|
            case shellword
            when /^\~/
              true if Regexp.new(shellword.sub('~','')) === (ENV['profile'] || ENV['p']).to_s
            when /=~/
              name, value = shellword.split('=~')
              #name = 'profile' if name.empty?
              true if Regexp.new(value) === ENV[name]
            when /=/
              name, value = shellword.split('=')
              #name = 'profile' if name.empty?
              true if subenv(value) == ENV[name]
            else
              true if shellword == (ENV['profile'] || ENV['p']).to_s
            end
          end

          if matches
            lines.shift while RE_PROFILE_HEADER =~ lines.first
            lines.shift while RE_BLANK_STRING   =~ lines.first
            parse_commands(lines)
          end
        end
        lines.shift
      end
    end

    #
    def parse_commands(lines)
      while line = lines.first
        line = line.strip
        if md = RE_COMMAND_HEADER.match(line)
          if current_command == line
            lines.shift while RE_COMMAND_HEADER =~ lines.first
            lines.shift while RE_BLANK_STRING =~ lines.first
            parse_environment(lines)
            parse_arguments(lines)
            next
          end
        elsif RE_PROFILE_HEADER.match(line)
          return
        end
        lines.shift
      end
    end

    #
    def parse_environment(lines)
      while line = lines.first
        line = line.strip
        next if line.empty?
        break unless line.start_with?('$ ')
        line = line.sub(/\$\s+/, '')
        shellwords(line).each do |s|
          name, value = s.split('=')
          @environment[name] = subenv(value) unless name.empty?
        end
        lines.shift
      end
    end

    #
    def parse_arguments(lines)
      while line = lines.first
        line = line.rstrip
        break if RE_PROFILE_HEADER =~ line
        break if RE_COMMAND_HEADER =~ line
        shellwords(line).each do |s|
          @arguments << subenv(s) unless s.empty?
        end
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

    #
    def shellwords(value)
      Shellwords.shellwords(value)
    end

    #
    def remove_initial_blank_lines(lines)
      lines.shift while RE_BLANK_STRING =~ lines.first
    end

  end

end
