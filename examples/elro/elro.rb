#!/usr/bin/ruby

require 'pi_piper'

class RemoteSwitch

  REPEAT = 10 # Number of transmissions
  DIP_OFF = 142
  DIP_ON  = 136

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
    @bit = [DIP_OFF, DIP_OFF, DIP_OFF, DIP_OFF, DIP_OFF, # key
            DIP_OFF, DIP_OFF, DIP_OFF, DIP_OFF, DIP_OFF, # device
            DIP_OFF, DIP_ON,                             # switch on/off
            128, 0, 0, 0]

    set_bits_for_key
    set_bits_for_device

    if switch
      @bit[10] = DIP_ON
      @bit[11] = DIP_OFF
    end

    pulses = get_pulses_from_bits

    @pin.off
    start_time = Time.now
    REPEAT.times do
      pulses.each do |b|
        @pin.update_value(b)
      end
    end
    end_time = Time.now
    puts "took %.0f microsecs per pulse" % ((end_time - start_time) / (10 * 16 * 8) * 1_000_000)
  end

private
  
  def set_bits_for_key
    0.upto(4) do |t|
      if @key[t] != 0
        @bit[t] = DIP_ON
      end
    end
  end

  def set_bits_for_device
    x=1
    5.upto(9) do |i|
      if @device & x > 0
        @bit[i] = DIP_ON
      end
      x = x<<1
    end
  end

  def get_pulses_from_bits
    pulses = []
    @bit.each do |bit|
      bitz = sprintf("%08d", bit.to_s(2)).split("").map {|b| b.to_i & 1 == 1}
      pulses.push(*bitz)
    end
    pulses
  end
end

if (!ARGV[0])
  exit(0)
end
RemoteSwitch.new(ARGV[0].to_i, [0,0,0,0,1], 17)._switch(ARGV[1] == "1")

