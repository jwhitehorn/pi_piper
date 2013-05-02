require 'elro_util'

# ElroSwitch is a little tool written to send trigger-events from a RaspberryPi 
# to an Elro remote controlled switch.
#
# It works perfectly with PiPiper: https://github.com/jwhitehorn/pi_piper
#
# See README.md for more information.
#
# == CREDITS
# Written by Torsten Mangner (https://github.com/alphaone).
# This library is mostly a (heavily refactored) port from this python script 
#   http://pastebin.com/aRipYrZ6
# by Heiko H.,
# which is a port from a C++ snippet
#   http://www.jer00n.nl/433send.cpp
# written by J. Lukas,
# and influenced by this Arduino source code
#   http://gathering.tweakers.net/forum/view_message/34919677
# written by Piepersnijder.
class ElroSwitch
  include ElroUtil

  # devices: according to dipswitches on your Elro receivers
  #          or 
  #          a numeric A = 1, B = 2, C = 4, D = 8, E = 16
  # key:     according to dipswitches on your Elro receivers
  # pin:     an object that responses to #update_value(bool) (like PiPiper::Pin)
  def initialize(device, key, pin)
    raise ArgumentError.new("key has to be of size 5") unless key.size == 5
    raise ArgumentError.new("device has to be Numeric or Array") unless (device.is_a?(Numeric) or device.is_a?(Array))
    raise ArgumentError.new("device has to be of size 5") if (device.is_a?(Array) and device.size != 5)
    raise ArgumentError.new("device has to be between 0 and 31") if (device.is_a?(Numeric) and !((0..31) === device))
    raise ArgumentError.new("pin has no method :update_value") unless pin.respond_to?(:update_value)
    @key = key
    @device = device
    @pin = pin
  end

  def switch(switch)
    sequence = []
    sequence << ElroUtil.sequence_for_key(@key)
    sequence << ElroUtil.sequence_for_device(@device)
    sequence << ElroUtil.sequence_for_onoff(switch)
    sequence << ElroUtil.sequence_for_static_part

    pulses = ElroUtil.pulses_from_sequence(sequence.flatten)
    ElroUtil.send_pulses(@pin, pulses)
  end

end
