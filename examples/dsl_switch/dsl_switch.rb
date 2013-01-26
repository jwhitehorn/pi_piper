require 'pi_piper'
include PiPiper

puts "Press the switch to get started"

watch :pin => 17, :invert => true do 
  puts "Pin changed from #{last_value} to #{value}"
end

PiPiper.wait

