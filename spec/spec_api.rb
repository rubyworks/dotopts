require_relative "helper"

describe DotOpts do

  it "can configure!" do
    ENV['cmd'] = 'yard'
    ARGV.replace([])

    example_avex_file = File.dirname(__FILE__) + '/fixtures/yard.opts'

    DotOpts.configure!(example_avex_file)

    ARGV[-2].assert == '--title'
    ARGV[-1].assert == 'Big Title'
  end

  it "can should not configure! when arguments are given" do
    ENV['cmd'] = 'yard'
    ARGV.replace(['--private'])

    example_avex_file = File.dirname(__FILE__) + '/fixtures/yard.opts'

    DotOpts.configure!(example_avex_file)

    ARGV[-1].assert == '--private'
  end

end

