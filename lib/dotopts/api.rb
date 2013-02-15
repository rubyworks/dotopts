module DotOpts
  require 'dotopts/parser'

  # Configuration file names.
  #
  # @note Sorry, I could not decide between these two.
  OPTIONS_FILES = ['.opts', '.option']

  # Configure
  #
  # @param [String] file
  #   The configuration file to load. (optional)
  #
  # @return [void]
  def self.configure!(io=nil)
    text, file = read_config(io)

    if text
      cmds = Parser.parse(text)

      applicable = cmds.select do |c|
        c.current?
      end

      applicable.each do |c|
        argv = c.arguments
        env  = c.environment

        debug(file, argv, env)
        apply(argv, env)
      end
    end
  end

  # Returns the options file of the current project.
  #
  # @return [String] The options file of the project.
  def self.options_file
    if project_root
      file = File.join(project_root, OPTIONS_FILE)
      return file if File.exist?(file)
    end
  end

  # Find the root directory of the current project.
  #
  # @return [String,nil] The root directory of the project.
  def self.project_root(start_dir=Dir.pwd)
    dir  = start_dir
    home = File.expand_path('~')
    until dir == home || dir == '/'
      OPTIONS_FILES.each do |optfile|
        if file = Dir[File.join(dir, optfile)].first
          return dir
        end
      end
      dir = File.dirname(dir)
    end
    nil
  end

  # Apply arguments and environment options.
  #
  # @return [void]
  def self.apply(argv, env={})
    env.each{ |k,v| ENV[k.to_s] = v.to_s }
    ARGV.concat(argv)
    #ARGV.replace(argv + ARGV)
  end

  # Print message to stderr if dopts_debug flag it set.
  #
  # @return [void]
  def self.debug(file, argv, env)
    return unless ENV['dotopts_debug'] 

    $stderr.puts "dotopts file: #{file}"

    unless argv.empty?
      msg = argv.join(' ')
      $stderr.puts "dotopts argv: " + msg
    end

    unless env.empty?
      msg = env.map{ |k,v| "#{k}=#{v.inspect}" }.join(' ')
      $stderr.puts "dotopts env: " + msg
    end
  end

  # Take an IO object and read it in. If it is a File
  # object also return the file name. Strings are passed
  # through untouched.
  #
  # @return [Array<String>]
  def self.read_config(io)
    text, file = nil, '(io)'

    case io
    when String
      text = io
    when File
      text = io.read
      file = io.path
    when nil
      if file = options_file
        text = File.read(file)
      end
    else
      text = io.read
    end

    return text, file
  end

end
