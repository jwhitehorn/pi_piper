require 'pi_piper'

puts "Press the switch to get started"
pin17 = PiPiper::Pin.new(:pin => 17, :direction => :out)
pin27 = PiPiper::Pin.new(:pin => 27, :direction => :out)

pin17.off
pin27.off

sum = 0

PiPiper.watch :pin => 22, :trigger => :rising do |pin|
  sum = sum + 1
  display = sum % 4
  puts sum 

  pin17.update_value(display == 2 || display == 3)
  pin27.update_value(display == 1 || display == 3)
end

PiPiper.wait

