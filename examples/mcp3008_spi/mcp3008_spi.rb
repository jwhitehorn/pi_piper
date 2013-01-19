require 'pi_piper'
#special thanks to Jeremy Blythe, and his article @ http://jeremyblythe.blogspot.com/2012/09/raspberry-pi-hardware-spi-analog-inputs.html
#it greatly helped in getting the MCP3008 setup with SPI

adc_num = 0 

loop do
  value = 0
  PiPiper::Spi.begin do |spi|
    raw = spi.write [1, (8+adc_num)<<4, 0] 
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
