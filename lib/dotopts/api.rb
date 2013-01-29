module DotOpts
  require 'dotopts/parser'

  #
  CONFIG_FILE = '.options'

  # Configure
  #
  # @param [String] configuraiton file
  #
  # @return nothing
  def self.configure!(file=nil)
    file = config_file unless file
    if file
      text = File.read(config_file)
      parser = Parser.parse(text)
      ARGV.concat parser.arguments
    end   
  end

  # Returns the `.ruby` file of the current project.
  #
  # @return {String] The .ruby file of the project.
  def self.config_file
    if project_root
      file = File.join(project_root, CONFIG_FILE)
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

end
