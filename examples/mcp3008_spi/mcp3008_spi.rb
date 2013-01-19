require 'pi_piper'

adc_num =0 

loop do
  value = 0
  PiPiper::Spi.begin do |spi|
    #spi.clock(PiPiper::Spi::CLOCK_DIVIDER_512)
    raw = spi.write [1, 128, 0] 
    value = ((raw[1]&3) << 8) + raw[2]
  end

  invert = 1023 - value
  mvolts = invert * (3300.0 / 1023.0)
  if mvolts < 2700
    temp = (mvolts - 380.0) / (2320.0 / 84.0)
  else
    temp = (mvolts - 2700.0) / (390.0 / 92.0) + 84.0
  end
  temp_f = (temp * 9.0 / 5.0) + 32
  puts "Value = #{value}, invert = #{invert}, mvolts = #{mvolts}, temp = #{temp} C | #{temp_f} F"
  sleep 1
end
