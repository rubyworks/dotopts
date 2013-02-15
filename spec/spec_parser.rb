require_relative "helper"

describe DotOpts::Parser do

  #before do
  #  ENV['cmd'] = 'yard'  # FIXME: try `foo` and watch what happens
  #end

  describe "without profiles" do
    it "can parse configuration" do
      text = "yard\n" +
             "  --title Super"
      cmds = DotOpts::Parser.parse(text)

      cmds.size.assert == 1
      cmds[0].name.assert == 'yard'
      cmds[0].arguments.assert == ['--title', 'Super']
      cmds[0].profile.assert.nil?
    end

    it "can parse configuration with multiple arguments" do
      text = "yard\n" +
             "  --title Super\n" +
             "  --private\n"
      cmds = DotOpts::Parser.parse(text)

      cmds.size.assert == 1
      cmds[0].name.assert == 'yard'
      cmds[0].arguments.assert == ['--title', 'Super', '--private']
      cmds[0].profile.assert.nil?
    end

    it "can parse configuration with multiple commands" do
      text = "yard\n" +
             "  --title Super\n" +
             "  --private\n" +
             "rdoc\n" +
             "  --private\n"
      cmds = DotOpts::Parser.parse(text)

      cmds.size.assert == 2

      cmds[0].name.assert == 'yard'
      cmds[0].arguments.assert == ['--title', 'Super', '--private']
      cmds[0].profile.assert.nil?

      cmds[1].name.assert == 'rdoc'
      cmds[1].arguments.assert == ['--private']
      cmds[1].profile.assert.nil?
    end
  end

  describe "with profiles" do
    it "can parse configuration with initial profile" do
      text = "[example]\n" +
             "yard\n" +
             "  --title Super"
      cmds = DotOpts::Parser.parse(text)

      cmds.size.assert == 1
      cmds.first.name.assert == 'yard'
      cmds.first.profile.assert == 'example'
      cmds.first.arguments.assert == ['--title', 'Super']
    end

    it "can parse configuration with multiple profiles" do
      text = "[something]\n" +
             "yard\n" +
             "  --title Sucky\n" +
             "\n" +
             "[example]\n" +
             "yard\n" +
             "  --title Super"

      cmds = DotOpts::Parser.parse(text)

      cmds.size.assert == 2

      cmds[0].name.assert == 'yard'
      cmds[0].profile.assert == 'something'
      cmds[0].arguments.assert == ['--title', 'Sucky']

      cmds[1].name.assert == 'yard'
      cmds[1].profile.assert == 'example'
      cmds[1].arguments.assert == ['--title', 'Super']
    end
  end

  #after do
  #  ENV['cmd'] = nil
  #end

end

