#!/usr/bin/env ruby

desc "Run demos."
task "qed" do
  require 'qed'
  QED.run!
end

desc "Run demos with coverage report."
task "qed:cov" do
  require 'qed'
  QED.run!('cov') do |c|
    require 'simplecov'
    SimpleCov.command_name 'QED'
    SimpleCov.start do
      coverage_dir 'log/coverage'
    end
  end
end

