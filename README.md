## Overview

[![Build Status](https://travis-ci.org/jwhitehorn/pi_piper.png)](https://travis-ci.org/jwhitehorn/pi_piper)

Pi Piper brings event driven programming to the Raspberry Pi's GPIO pins. Pi Piper works with all revisions of the Raspberry Pi,
and has been tested with Ruby 1.9.3 & 2.0 under both [Raspbian "wheezy"](http://www.raspberrypi.org/downloads) and [Occidentalis v0.2](http://learn.adafruit.com/adafruit-raspberry-pi-educational-linux-distro/occidentalis-v0-dot-2).

To get started:

If you do not already have Ruby installed, first you'll need to:

    sudo apt-get install ruby ruby1.9.1-dev

Despite one of the packages being titled "ruby1.9.1-dev", the above command will install Ruby 1.9.3 (as of January 2013) and the Ruby dev tools.

To install Pi Piper:

    sudo gem install pi_piper

### GPIO

The GPIO pins (or General Purpose I/O pins) are the primary "do anything" pins on the Raspberry Pi. Reading inputs from them is as simple as:

```ruby
require 'pi_piper'
include PiPiper

watch :pin => 23 do
  puts "Pin changed from #{last_value} to #{value}"
end

#Or

after :pin => 23, :goes => :high do
  puts "Button pressed"
end

PiPiper.wait
```

Your block will be called when a change to the pin's state is detected.

When using pins as input, you can use internal resistors to pull the pin
up or pull down. This is important if you use open-collector sensors
which have floating output in some states.

You can set resistors when creating a pin passing a :pull parameter
(which can be :up, :down or :off, which is the default).

```ruby
pin = PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :up)
```

This way, the pin will always return 'on' if it is unconnected or of the
sensor has an open collector output.

You can later alter the pulling resistors using PiPiper#pull!

Additionally you can use pins as output too:

```ruby
pin = PiPiper::Pin.new(:pin => 17, :direction => :out)
pin.on
sleep 1
pin.off
```

_please note, in the above context "pin" refers to the GPIO number of the Raspberry Pi._

### SPI
Starting with version 1.2, Pi Piper offers SPI support.

```ruby
PiPiper::Spi.begin do
  puts write [0x01, 0x80, 0x00]
end
```

If you are using an operating system that supports `/dev/spidev0.0` like the [adafruit
distro][adafruit-linux] you can also write to the spi using `PiPiper::Spi.spidev_out`

```ruby
# Example writing red, green, blue to a string of WS2801 pixels
PiPiper::Spi.spidev_out([255,0,0,0,255,0,0,0,255])
```
[adafruit-linux]:http://learn.adafruit.com/adafruit-raspberry-pi-educational-linux-distro/overview

### Pulse Width Modulation (PWM)

what is it !? https://en.wikipedia.org/wiki/Pulse-width_modulation

PiPiper allow to use the hardware PWM channel of the bcm2835.....
value should be between 0 and 1, clock between 0 and 19.2MHz, mode blaanced or markspace and range something greater than 0.
Supported pin are : 12, 13, 18, 19, 40, 41, 45, 52, 53
but only 18 is on the header..

```ruby
pwm = PiPiper::Pwm.new pin: 18 #, range: 1024, clock: 19.2.megahertz, mode: :markspace, value: 1, start: false
pwm.value= 0.5
pwm.off # works with stop
pwm.on  # aliased start
```

apparently the clock is rounded to the next 2^n divider of 19.2MHz

## Documentation

API documentation for Pi Piper can be found at [rdoc.info](http://rdoc.info/github/jwhitehorn/pi_piper/frames/).

## Example projects

Looking for more examples/sample code for Pi Piper? Then check out the following example projects, complete with circuit diagrams:

* [Project 1: Morse Code](https://github.com/jwhitehorn/pi_piper/wiki/Project-1:-Morse-Code)
* [Project 2: Simple Switch](https://github.com/jwhitehorn/pi_piper/wiki/Project-2:-Simple-Switch)
* [Project 3: 2-bit counter](https://github.com/jwhitehorn/pi_piper/wiki/Project-3:-2-bit-counter)
* [Project 4: MCP3008](https://github.com/jwhitehorn/pi_piper/wiki/Project-4:-MCP3008)

## Under the hood

PiPiper use the libbcm2835 library from Mike McCauley at airspayce.

http://www.airspayce.com/mikem/bcm2835/index.html

if you want to upgrade or downgrade the library for compatibility reason, get it and make it a shared object library :

```script
wget http://www.airspayce.com/mikem/bcm2835/bcm2835-1.49.tar.gz
tar zxvf bcm2835-1.49.tar.gz && cd bcm2835-1.49
./configure && make
sudo make check
sudo make install
cd src && cc -shared bcm2835.o -o libbcm2835.so
cp libbcm2835.so ~/pi_piper/lib/pi_piper

## License

Copyright (c) 2013, [Jason Whitehorn](https://github.com/jwhitehorn)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.



***
<img src="http://www.raspberrypi.org/wp-content/uploads/2012/03/Raspi_Colour_R.png" width="90" />

Proudly developed exclusively on a [Raspberry Pi](http://www.raspberrypi.org)
