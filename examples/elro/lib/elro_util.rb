# ElroUtil will do the hard work for ElroSwitch
#
# == WARNING
# The Raspberry is not build to be the fastest hardware in the world.
# Ruby (MRI) is not fastest programming language (but still the best).
# The Elro Switch expects the 1280 signals for each switch-event to be 
# transmitted with a frequency of 300 microseconds (but as I have observed
# will still operate while using frequencies from ≈100 to ≈600 microseconds
# per signal).
#
# This implementation (using PiPiper) reaches a frequency of around 
# 500 microseconds on an RaspberryPi without any wait or sleep.
#
# Other implementation (in python or C) need to time their signals to
# not be too fast.
#
# Keep that in mind, if this code will run on faster hardware or faster Rubies.
module ElroUtil

  DIP_OFF = 142
  DIP_ON  = 136
  REPEAT = 10 # Number of transmissions

  def ElroUtil.sequence_for_key(key)
    key.map { |dip| (dip == 1) ? DIP_ON : DIP_OFF }
  end

  def ElroUtil.sequence_for_device(device)
    if device.is_a?(Array)
      device.map { |dip| dip == 1 ? DIP_ON : DIP_OFF }
    elsif device.is_a?(Numeric)
      ElroUtil.convert_to_bits(device, 5).reverse.map { |b| b ? DIP_ON : DIP_OFF }
    end
  end

  def ElroUtil.sequence_for_onoff(switch_on)
    switch_on ? [DIP_ON, DIP_OFF] : [DIP_OFF, DIP_ON]
  end

  def ElroUtil.sequence_for_static_part
    [128, 0, 0, 0]
  end

  def ElroUtil.pulses_from_sequence(sequence)
    sequence.map { |part| ElroUtil.convert_to_bits(part, 8) }.flatten
  end

  def ElroUtil.send_pulses(pin, pulses, verbose=false)
    pin.update_value(false)
    start_time = Time.now
    REPEAT.times do
      pulses.each { |b| pin.update_value(b) }
    end
    end_time = Time.now
    if verbose
      puts "avg %.0f microsecs per pulse" % ((end_time - start_time) / (10 * 16 * 8) * 1_000_000)
    end
  end

  def ElroUtil.convert_to_bits(num, length)
    sprintf("%0#{length}d", num.to_s(2)).split("").map {|b| b.to_i & 1 == 1}
  end

end
