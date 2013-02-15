require_relative "helper"

describe DotOpts do

  it "can configure!" do
    ARGV.replace([])
    ENV['cmd'] = 'yard'  # FIXME: try `foo` and watch what happens

    example_avex_file = File.dirname(__FILE__) + '/fixtures/yard.opts'

    DotOpts.configure!(example_avex_file)

    ARGV[-2].assert == '--title'
    ARGV[-1].assert == 'Big Title'
  end

end

