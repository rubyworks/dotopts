module DotOpts

  class Parser
    require 'shellwords'
    require_relative 'command'

    # Regular expression to match profile headers.
    RE_PROFILE = /^\[(.*)\]/

    # Regular expression to match command headers.
    RE_COMMAND = /^\w/

    # Regular expression to match arguments.
    RE_ARGUMENT = /^\s+\S+/

    # Regular expression to match environment setting.
    RE_ENVIRONMENT = /^\s+\$/

    # Regular expression to match blank strings.
    RE_BLANK = /^\s*$/

    # Convenience constructor for `new(text).parse`.
    #
    # @return [Parser]
    def self.parse(text)
      parser = new(text)
      parser.parse
      parser.commands
    end

    # Initialize new instance.
    #
    # @param [#to_s] text
    #
    def initialize(text)
      @text = text.to_s

      #
      @commands = []

      # Holds the current commands being parsed.
      @_commands = []
      @_profiles = []
    end

    #
    attr :commands

    # The configuration document text. [String]
    attr :text

    # Parse the configuration text.
    #
    #
    def parse
      lines = @text.lines.to_a

      remove_blanks(lines)

      # put initial non-profiled settings last 
      #if lines.first !~ RE_PROFILE
      #  index = lines.index{ |line| line =~ RE_PROFILE }
      #  if index
      #    lines = lines[index..-1] + ['[]'] + lines[0...index]
      #  else
      #    #lines = ['[]'] + lines
      #  end
      #end

      parse_profiles(lines)
    end

    #
    #
    #
    def parse_profiles(lines)
      @_profiles = []
      until lines.empty?
        line = lines.first.rstrip
        case line
        when RE_BLANK
          lines.shift
        when RE_PROFILE
          @_profiles << $1
          lines.shift
        else
          #@_commands = []
          parse_command(lines)
        end
      end
    end

    # Parse lines from command onward until another profile
    # or end of document is reached.
    #
    # @return [void]
    def parse_command(lines)
      previous = nil
      while line = lines.first
        case line
        when RE_BLANK
        when RE_COMMAND
          if previous != :command
            @commands.concat @_commands
            @_commands = []
          end
          if @_profiles.empty?
            @_commands << Command.new(line.strip, :profile=>nil)
          else
            @_profiles.each do |profile|
              @_commands << Command.new(line.strip, :profile=>profile)
            end
          end
          previous = :command
        when RE_ARGUMENT, RE_ENVIRONMENT
          if @_commands.empty?
            raise SyntaxError, "no command before arguments\n@ #{line}"
          end
          @_commands.each{ |c| c << line }
          previous = :argument
        when RE_PROFILE
          @commands.concat @_commands
          @_commands = []
          @_profiles = []
          return
        end
        lines.shift
      end
      @commands.concat @_commands
    end

    # Remove intialize blank lines for an array of strings.
    #
    # @param [Array<String>] lines
    #
    # @return [Array<String>]
    def remove_blanks(lines)
      lines.shift while RE_BLANK =~ lines.first
    end

  end

end

=begin
    # Parse profiles.
    def parse_profiles(lines)
      until lines.empty?
        line = lines.first.rstrip
        if md = RE_PROFILE_HEADER.match(line)  # TODO: this is a bit wanky
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

    # Parse commands.
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

    # Parse environment.
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

    # Parse arguments.
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

    # The current command comes from the basename of `$0`.
    # But it can be overriddne by setting the `cmd` environment variable.
    #
    # @return [String]
    def current_command
      ENV['cmd'] || File.basename($0)
    end
  end

end

=end
