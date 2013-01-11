require 'pi_piper'

unit = 0.1
dot = unit
dash = unit * 3
inter_element_gap = unit
short_gap = unit * 3
medium_gap = unit * 7

#http://en.wikipedia.org/wiki/Morse_code
character_timing = { "a" => [dot, dash],             "b" => [dash, dot, dot, dot],   "c" => [dash, dot, dash, dot],
                     "d" => [dash, dot, dot],        "e" => [dot],                   "f" => [dot, dot, dash, dot], 
                     "g" => [dash, dash, dot],       "h" => [dot, dot, dot, dot],    "i" => [dot, dot],
                     "j" => [dot, dash, dash, dash], "k" => [dash, dot, dash],       "l" => [dot, dash, dot, dot],
                     "m" => [dash, dash],            "n" => [dash, dot],             "o" => [dash, dash, dash],
                     "p" => [dot, dash, dash, dot],  "q" => [dash, dash, dot, dash], "r" => [dot, dash, dot],
                     "s" => [dot, dot, dot],         "t" => [dash],                  "u" => [dot, dot, dash],
                     "v" => [dot, dot, dot, dash],   "w" => [dot, dash, dash],       "x" => [dash, dot, dot, dash],
                     "y" => [dash, dot, dash, dash], "z" => [dash, dash, dot, dot]} 

pin = PiPiper::Pin.new(:pin => 17, :direction => :out)
pin.off

loop do
  puts "Please type something"
  something = gets.chomp.downcase

  something.each_char do |letter|
    if letter == " "
      pin.off
      sleep medium_gap
    else
      character_timing[letter].each do |timing| 
        pin.on
        sleep timing
        pin.off
        sleep inter_element_gap
      end
      sleep short_gap - inter_element_gap
    end
  end

end
