require_relative "helper"

describe DotOpts::Parser do

  before do
    ENV['cmd'] = 'yard'  # FIXME: try `foo` and watch what happens
  end

  context "without profiles" do

    it "can parse configuration" do
      text = "yard\n" +
             "  --title Super"
      parser = DotOpts::Parser.parse(text)

      parser.arguments.assert == ['--title', 'Super']
    end

    it "can parse configuration with multiple arguments" do
      text = "yard\n" +
             "  --title Super\n" +
             "  --private\n"

      parser = DotOpts::Parser.parse(text)

      parser.arguments.assert == ['--title', 'Super', '--private']
    end

  end

  context "with profiles" do

    it "can parse configuration with initial profile" do
      text = "[example]\n" +
             "yard\n" +
             "  --title Super"

      parser = with_environment('profile'=>'example') do
        DotOpts::Parser.parse(text)
      end

      parser.arguments.assert == ['--title', 'Super']
    end

    it "can parse configuration with lower profile" do
      text = "[something]\n" +
             "yard\n" +
             "  --title Sucky\n" +
             "\n" +
             "[example]\n" +
             "yard\n" +
             "  --title Super"

      parser = with_environment('profile'=>'example') do
        DotOpts::Parser.parse(text)
      end

      parser.arguments.assert == ['--title', 'Super']
    end

  end


  after do
    ENV['cmd'] = nil
  end

end

