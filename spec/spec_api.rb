require_relative "helper"

describe DotOpts do

  it "can configure!" do
    ENV['cmd'] = 'yard'  # FIXME: try `foo` and watch what happens

    example_avex_file = File.dirname(__FILE__) + '/fixtures/yard.avex'

    DotOpts.configure!(example_avex_file)

    ARGV.last.assert == '--title "Big Title"'
  end

end

