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

    for t in 0..4 do
      if @key[t]!=0
        @bit[t]=136
      end
    end

    x=1
    for i in 5..9 do
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
    for y in 0..15 do
      x = 128
      for i in 1..8 do
        b = (@bit[y] & x > 0) ? true : false
        pulses << b
        x = x>>1
      end
    end

    @pin.off
    starttime = Time.now
    REPEAT.times do
      for b in pulses do
        @pin.update_value(b)
# do not sleep, since raspberrypi take around 500 microseconds to the pin.update_value(b)
#        sleep(PULSE_LENGTH / 1_000_000.0)
      end
    end
    endtime = Time.now
    puts "took %.0f microsecs per pulse" % ((endtime - starttime) / (10 * 16 * 8) * 1_000_000)
  end
end

if (!ARGV[0])
  exit(0)
end
RemoteSwitch.new(ARGV[0].to_i, [0,0,0,0,1], 17)._switch(ARGV[1] == "1")