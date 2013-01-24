require_relative "helper"

describe DotOpts::Parser do

  before do
    ENV['cmd'] = 'yard'  # FIXME: try `foo` and watch what happens
  end

  it "can parse configuration without profiles" do
    text = "yard\n" +
           "  --title Super"
    parser = DotOpts::Parser.parse(text)

    parser.arguments.assert == ['--title Super']
  end

  it "can parse configuration with multiple arguments" do
    text = "yard\n" +
           "  --title Super\n" +
           "  --private\n"

    parser = DotOpts::Parser.parse(text)

    parser.arguments.assert == ['--title Super', '--private']
  end

  after do
    ENV['cmd'] = nil
  end

end

