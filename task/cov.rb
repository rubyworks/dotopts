# Coverage Report
#
# To use require `task/cov`, e.g.
#
#   $ qed -r./task/cov
#
require 'simplecov'
SimpleCov.command_name File.basename($0)
SimpleCov.start do
  coverage_dir 'log/coverage'
end

