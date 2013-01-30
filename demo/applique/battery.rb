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

  @opts_parser = DotOpts::Parser.parse(@opts_text)
end

When 'we should get the arguments' do |text|
  args = text.split("\n").map{ |x| x.strip }
  args.assert == @opts_parser.arguments
end

