require 'pi_piper'

puts "Press the switch to get started"

PiPiper.watch :pin => 17 do |pin|
  puts "Pin changed from #{pin.last_value} to #{pin.value}"
end

PiPiper.wait

