#!/usr/bin/ruby

require 'pi_piper'

class RemoteSwitch

  REPEAT = 10 # Number of transmissions
  PULSE_LENGTH = 300 # microseconds

  # devices: A = 1, B = 2, C = 4, D = 8, E = 16
  # key: according to dipswitches on your Elro receivers
  # pin: according to Broadcom pin naming
  def initialize(device, key=[1,1,1,1,1], pin=17)
    @key = key
    @device = device
    @pin = PiPiper::Pin.new(:pin => pin, :direction => :out)
  end

  def switchOn
    self._switch(true)
  end

  def switchOff
    self._switch(false)
  end

  def _switch(switch)
    @bit = [142, 142, 142, 142, 142, 142, 142, 142, 142, 142, 142, 136, 128, 0, 0, 0]

    0.upto(4) do |t|
      if @key[t]!=0
        @bit[t]=136
      end
    end

    x=1
    5.upto(9) do |i|
      if @device & x > 0
        @bit[i] = 136
      end
      x = x<<1
    end

    if switch
      @bit[10] = 136
      @bit[11] = 142
    end

    pulses = []
    0.upto(15) do |y|
      x = 128
      1.upto(8) do |i|
        b = @bit[y] & x > 0
        pulses << b
        x = x>>1
      end
    end

    @pin.off
    start_time = Time.now
    last_time = Time.now

    REPEAT.times do

      pulses.each do |b|
        while(current_time = Time.now; current_time < last_time + PULSE) do
          sleep(PULSE / 1_000)
        end
        @pin.update_value(b)
        last_time = current_time
      end

    end
    
    end_time = Time.now
    puts "took %.0f microsecs per pulse" % ((end_time - start_time) / (10 * 16 * 8) * 1_000_000)
  end
end

if (!ARGV[0])
  exit(0)
end
RemoteSwitch.new(ARGV[0].to_i, [0,0,0,0,1], 17)._switch(ARGV[1] == "1")