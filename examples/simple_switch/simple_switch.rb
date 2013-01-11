require 'pi_piper'

PiPiper.watch :pin => 17 do |pin|
  puts "Pin changed from #{pin.last_value} to #{pin.value}"
end

PiPiper.wait

