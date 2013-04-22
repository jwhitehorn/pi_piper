#!/usr/bin/ruby
require 'pi_piper'
require 'elro_switch'

if (!ARGV[0])
  exit(0)
end

pin = PiPiper::Pin.new(:pin => 17, :direction => :out)
ElroSwitch.new(ARGV[0].to_i, [0,0,0,0,1], pin).switch(ARGV[1] == "1")
