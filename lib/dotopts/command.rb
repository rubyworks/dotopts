module DotOpts

  # Get the current command.
  #
  # @note This is take from basename of `$0`. In the future, we may
  #       need to find a way to tweak this to somehow include parrent
  #       directories.
  #
  # @todo Is ENV['cmd'] okay? Maybe ['dotopts_command'] would be better?
  def self.command
    ENV['cmd'] || File.basename($0)
  end

  ##
  # Command class encapsulate a configuration for a given command and
  # a given profile.
  #
  class Command

    # Initialize new instance of Command.
    #
    # @param [String] name
    #   The name of the command. Can include subcommand, e.g. `yard doc`.
    #
    # @option settings [String,nil] :profile
    #   The profile for which this command configuation would be applicable.
    #
    # @return [void]
    def initialize(name, settings={})
      @name = name

      self.profile = settings[:profile]

      @arguments   = []
      @environment = {}
    end

    # Command name. [String]
    attr :name

    # Profile designation.
    #
    # @return [String,nil]
    def profile
      @profile
    end

    # Set profile designation.
    #
    # @param [String,nil] 
    #   The profile designation.
    #
    # @return [String,nil]
    def profile=(profile)
      @profile = profile ? profile.to_str : nil  #? shellwords(profile).first : nil
    end

    # Environment settings.
    #
    # @return [Hash]
    def environment
      @environment
    end

    # Arguments.
    #
    # @return [Array]
    def arguments
      @arguments
    end

    # Add argument or environment entries to command.
    #
    # TODO: Is there too much "parsing" going on here?
    #       Should some of this be in Parser instead?
    def <<(entry)
      entry = entry.strip
      if entry.start_with?('$ ')
        # environment
        entry.sub!(/\$\s+/, '')
        shellwords(entry).each do |s|
          name, value = s.split('=')
          @environment[name] = subenv(value) unless name.empty?
        end
      else
        # argument
        shellwords(entry).each do |s|
          @arguments << subenv(s) unless s.empty?
        end
      end
    end

    # Is the command applicable to the current command line?
    #
    # @return [Boolean]
    def current?
      command? && profile?
    end

    # Does the command's name match the current command?
    #
    # @return [Boolean]
    def command?
      this = @name.split(' ')
      real = [DotOpts.command, *ARGV][0,this.size]
      this == real && ARGV.size < this.size  # no other arguments
    end

    # Does the command's profile match the current environment?
    #
    # @return [Boolean]
    def profile?
      case profile = profile()
      when /^\~/
        true if Regexp.new(profile.sub('~','')) === (ENV['profile'] || ENV['p']).to_s
      when /=~/
        name, value = profile.split('=~')
        #name = 'profile' if name.empty?
        true if Regexp.new(value) === ENV[name]
      when /=/
        name, value = profile.split('=')
        #name = 'profile' if name.empty?
        true if subenv(value) == ENV[name]
      else
        true if profile.to_s == (ENV['profile'] || ENV['p']).to_s
      end
    end

  private

    # Split a string up into shellwords.
    #
    # @return [Array]
    def shellwords(value)
      Shellwords.shellwords(value)
    end

    # Substitute environment variables.
    #
    # @return [String]
    def subenv(value)
      value.gsub(/\$(\w+)/){ |m| ENV[$1] }
    end

  end

end
