# Coverage Report
#
#   $ rubytest -c etc/cov
#
Test.configure do |run|
  run.files << 'spec/**/spec_*.rb'
  run.requires << ['ae', 'spectroscope']
  run.before do
    require 'simplecov'
    SimpleCov.command_name(File.basename($0))
    SimpleCov.start do
      add_filter "spec/"
      coverage_dir 'log/coverage'
    end
  end
end

