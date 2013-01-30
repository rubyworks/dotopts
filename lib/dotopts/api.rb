module DotOpts
  require 'dotopts/parser'

  #
  OPTIONS_FILE = '.option'

  # Configure
  #
  # @param [String] file
  #   The configuration file to load. (optional)
  #
  # @return nothing
  def self.configure!(file=nil)
    file = options_file unless file
    if file
      text   = File.read(file)
      parser = Parser.parse(text)

      argv = parser.arguments
      env  = parser.environment

      debug(file, argv, env)
      apply(argv, env)
    end
  end

  # Returns the options file of the current project.
  #
  # @return {String] The options file of the project.
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
      if file = Dir[File.join(dir, '{.ruby,.git,.hg}')].first
        return dir
      end
      dir = File.dirname(dir)
    end
    nil
  end

  # Apply arguments and environment options.
  #
  # TODO: Support argument prepending in future version?
  #
  def self.apply(argv, env={})
    env.each{ |k,v|  ENV[k.to_s] = v.to_s }
    ARGV.concat(argv)
  end

  # Print message to stderr if dopts_debug flag it set.
  #
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

end
