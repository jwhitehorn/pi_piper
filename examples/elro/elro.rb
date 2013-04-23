#!/usr/bin/ruby
require 'pi_piper'
require 'elro_switch'

exit(0) unless ARGV[0]

device = ARGV[0].to_i
switch_on = ARGV[1]
key = [0,0,0,0,1]

pin = PiPiper::Pin.new(:pin => 17, :direction => :out)
elro = ElroSwitch.new(device, key, pin)
elro.switch(switch_on == "1")
