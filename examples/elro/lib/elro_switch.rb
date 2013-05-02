require 'elro_util'

class ElroSwitch
  include ElroUtil

  # devices: according to dipswitches on your Elro receivers
  #          or 
  #          a numeric A = 1, B = 2, C = 4, D = 8, E = 16
  # key:     according to dipswitches on your Elro receivers
  # pin:     an object that responses to #off and #updated_value(bool) (like PiPiper::Pin)
  def initialize(device, key, piper_pin)
    raise ArgumentError.new("key has to be of size 5") unless key.size == 5
    raise ArgumentError.new("device has to be Numeric or Array") unless (device.is_a?(Numeric) or device.is_a?(Array))
    raise ArgumentError.new("device has to be of size 5") if (device.is_a?(Array) and device.size != 5)
    raise ArgumentError.new("device has to be between 0 and 31") if (device.is_a?(Numeric) and !((0..31) === device))
    @key = key
    @device = device
    @pin = piper_pin
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
