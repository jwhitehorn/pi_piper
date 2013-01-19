require 'pi_piper'

s7 = PiPiper::Pin.new(:direction => :out, :pin => 17)
s5 = PiPiper::Pin.new(:direction => :out, :pin => 18)
s6 = PiPiper::Pin.new(:direction => :out, :pin => 22)
s3 = PiPiper::Pin.new(:direction => :out, :pin => 23)
s2 = PiPiper::Pin.new(:direction => :out, :pin => 24)
s4 = PiPiper::Pin.new(:direction => :out, :pin => 25)
s1 = PiPiper::Pin.new(:direction => :out, :pin => 27)


pins = [s1, s2, s3, s4, s5, s6, s7]

zero = Proc.new { s1.on; s2.on; s3.on; s4.on; s5.on; s6.on; s7.off; }
one = Proc.new { s1.off; s2.off; s3.on; s4.on; s5.off; s6.off; s7.off; }
two = Proc.new { s1.off; s2.on; s3.on; s4.off; s5.on; s6.on; s7.on; }
three = Proc.new { s1.off; s2.on; s3.on; s4.on; s5.on; s6.off; s7.on; }
four = Proc.new { s1.on; s2.off; s3.on; s4.on;; s5.off; s6.off; s7.on; }
five = Proc.new { s1.on; s2.on; s3.off; s4.on; s5.on; s6.off; s7.on; }
six = Proc.new { s1.on; s2.on; s3.off; s4.on; s5.on; s6.on; s7.on; }
seven = Proc.new { s1.off; s2.on; s3.on; s4.on; s5.off; s6.off; s7.off; }
eight = Proc.new { s1.on; s2.on; s3.on; s4.on; s5.on; s6.on; s7.on; }
nine = Proc.new { s1.on; s2.on; s3.on; s4.on; s5.off; s6.off; s7.on; }

numbers = [zero, one, two, three, four, five, six, seven, eight, nine]

pins.each { |p| p.off }

loop do
  (0..1000).each do
    pins.each { |p| p.update_value(Random.rand(2) == 1) }
  end
  number = Random.rand(10)
  numbers[number].call
  sleep 2
end
