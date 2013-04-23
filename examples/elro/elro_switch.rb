require 'elro_util'

class ElroSwitch

  # devices: A = 1, B = 2, C = 4, D = 8, E = 16
  # key: according to dipswitches on your Elro receivers
  # pin: according to Broadcom pin naming
  def initialize(device, key=[1,1,1,1,1], piper_pin)
    raise ArgumentError.new("key has to be of size 5") if key.size != 5
    @key = key
    @device = device
    @pin = piper_pin
  end

  def switch(switch)
    sequence = []
    sequence << ElroUtil.sequence_for_key(@key)
    sequence << ElroUtil.sequence_for_device(@device)
    sequence << (switch ? [ElroUtil::DIP_ON, ElroUtil::DIP_OFF] : [ElroUtil::DIP_OFF, ElroUtil::DIP_ON])
    sequence << [128, 0, 0, 0]

    pulses = ElroUtil.pulses_from_sequence(sequence.flatten)
    ElroUtil.send_pulses(@pin, pulses)
  end

end
