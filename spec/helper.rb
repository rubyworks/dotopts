require 'spectroscope'
require 'ae'

require 'dotopts/api'

def with_environment(hash)
  hold = {}
  hash.each do |name, value|
    name, value = name.to_s, value.to_s
    hold[name], ENV[name] = ENV[name], value
  end
  begin
    yield
  ensure
    hold.each do |name, value|
      ENV[name] = value
    end
  end
end
