class ElroSwitch

  REPEAT = 10 # Number of transmissions
  DIP_OFF = 142
  DIP_ON  = 136

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
    sequence << ElroSwitch.sequence_for_key(@key)
    sequence << ElroSwitch.sequence_for_device(@device)
    sequence << (switch ? [DIP_ON, DIP_OFF] : [DIP_OFF, DIP_ON])
    sequence << [128, 0, 0, 0]

    ElroSwitch.send_pulses(@pin, ElroSwitch.pulses_from_sequence(sequence.flatten))
  end

private
  
  def ElroSwitch.sequence_for_key(key)
    key.map { |dip| (dip == 1) ? DIP_ON : DIP_OFF }
  end

  def ElroSwitch.sequence_for_device(device)
    ElroSwitch.convert_to_bits(device, 5).reverse.map { |b| b ? DIP_ON : DIP_OFF }
  end

  def ElroSwitch.pulses_from_sequence(sequence)
    sequence.map { |part| ElroSwitch.convert_to_bits(part, 8) }.flatten
  end

  def ElroSwitch.send_pulses(pin, pulses)
    pin.off
    start_time = Time.now
    REPEAT.times do
      pulses.each { |b| pin.update_value(b) }
    end
    end_time = Time.now
    puts "avg %.0f microsecs per pulse" % ((end_time - start_time) / (10 * 16 * 8) * 1_000_000)
  end

  def ElroSwitch.convert_to_bits(num, length)
    sprintf("%0#{length}d", num.to_s(2)).split("").map {|b| b.to_i & 1 == 1}
  end

end
