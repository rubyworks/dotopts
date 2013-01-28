#!/usr/bin/env ruby

profile 'cov' do

  QED.configure do
    # coverage report
    require 'simplecov'
    SimpleCov.command_name 'QED'
    SimpleCov.start do
      coverage_dir 'log/coverage'
    end
  end

end

