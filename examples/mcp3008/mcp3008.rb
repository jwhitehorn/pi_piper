require 'pi_piper'
#port of the Adafruit MCP3008 interface code found @ http://learn.adafruit.com/send-raspberry-pi-data-to-cosm/python-script

def read_adc(adc_pin, clockpin, adc_in, adc_out, cspin)
  cspin.on
  clockpin.off
  cspin.off
  
  command_out = adc_pin
  command_out |= 0x18
  command_out <<= 3

  (0..4).each do
    adc_in.update_value((command_out & 0x80) > 0)
    command_out <<= 1
    clockpin.on
    clockpin.off
  end
  result = 0

  (0..11).each do
    clockpin.on
    clockpin.off
    result <<= 1
    adc_out.read
    if adc_out.on?
      result |= 0x1
    end
  end 

  cspin.on

  result >> 1
end
  
clock = PiPiper::Pin.new :pin => 18, :direction => :out
adc_out = PiPiper::Pin.new :pin => 23
adc_in = PiPiper::Pin.new :pin => 24, :direction => :out
cs = PiPiper::Pin.new :pin => 25, :direction => :out

adc_pin = 0

loop do
  value = read_adc(adc_pin, clock, adc_in, adc_out, cs)
  puts "Value = #{value}"
  sleep 1
end
