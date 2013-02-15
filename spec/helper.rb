if ENV['RUBYOPT'].to_s.include?('-rdotopts')
  abort "Remove `-rdotopts` from RUBYOPT environment first."
end

require 'spectroscope'
require 'ae'

require 'dotopts/api'

module Kernel

  def with_env(hash)
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

end
