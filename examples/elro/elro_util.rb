class ElroUtil

  DIP_OFF = 142
  DIP_ON  = 136
  REPEAT = 10 # Number of transmissions

  def ElroUtil.sequence_for_key(key)
    key.map { |dip| (dip == 1) ? DIP_ON : DIP_OFF }
  end

  def ElroUtil.sequence_for_device(device)
    ElroUtil.convert_to_bits(device, 5).reverse.map { |b| b ? DIP_ON : DIP_OFF }
  end

  def ElroUtil.pulses_from_sequence(sequence)
    sequence.map { |part| ElroUtil.convert_to_bits(part, 8) }.flatten
  end

  def ElroUtil.send_pulses(pin, pulses)
    pin.off
    start_time = Time.now
    REPEAT.times do
      pulses.each { |b| pin.update_value(b) }
    end
    end_time = Time.now
    puts "avg %.0f microsecs per pulse" % ((end_time - start_time) / (10 * 16 * 8) * 1_000_000)
  end

  def ElroUtil.convert_to_bits(num, length)
    sprintf("%0#{length}d", num.to_s(2)).split("").map {|b| b.to_i & 1 == 1}
  end

end
