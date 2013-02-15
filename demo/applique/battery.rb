When "Given a `.option` file" do |text|
  ENV.replace({})
  ARGV.replace([])

  @opts_parser = nil
  @opts_text   = text
end

When 'we run `/(.*?)/`' do |command|
  args = command.split(/\s+/)

  while (/=/ =~ args.first)
    name, value = args.shift.split('=')
    ENV[name] = value
  end

  ENV['cmd'] = args.shift
  ARGV.replace(args)

  DotOpts.configure!(@opts_text)
end

When 'we should get the arguments' do |text|
  #opts_args = []
  #@opts_cmds.each do |c|
  #  next unless c.current?
  #  opts_args += c.arguments
  #end

  args = text.split("\n").map{ |x| x.strip }
  args.assert == ARGV #opts_args
end

