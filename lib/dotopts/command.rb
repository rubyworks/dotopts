module DotOpts

  # TODO: is ENV['cmd'] okay? Maybe ['dotopts_command'] would be better?
  def self.command
    ENV['cmd'] || File.basename($0)
  end

  #
  class Command
    #
    def initialize(name, settings={})
      @name = name

      self.profile = settings[:profile]

      @arguments   = []
      @environment = {}
    end

    # Command name. [String]
    attr :name

    #
    def profile
      @profile
    end

    #
    def profile=(profile)
      @profile = profile ? profile.to_str : nil  #? shellwords(profile).first : nil
    end

    #
    def environment
      @environment
    end

    #
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

    #
    def current?
      command? && profile?
    end

    # Does the command's name match the current command?
    def command?
      this = @name.split(' ')
      real = [DotOpts.command, *ARGV][0,this.size]
      this == real
    end

    # Does the command's profile match the current environment?
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
