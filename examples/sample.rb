require 'pi_piper'

PiPiper.watch :pin => 23 do |pin|
  puts "Pin changed from #{pin.last_reading} to #{pin.reading}"
end

PiPiper.wait

