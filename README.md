## Overview

Pi Piper brings event driven programming to the Raspberry Pi's GPIO pins. To get started:

    sudo gem install pi_piper

Sample usage:
```ruby
require 'pi_piper'

PiPiper.watch :pin => 23 do |pin|
  puts "Pin changed from #{pin.last_value} to #{pin.value}"
end

PiPiper.wait
```

Your block will be called when a change to the pin's state is detected.

Additionally you can use pins as output too:

```ruby
pin = PiPiper::Pin.new(:pin => 17, :direction => :out)
pin.on
sleep 1
pin.off
```

## Example projects

Looking for more examples/sample code for Pi Piper? Then check out the following example projects, complete with circuit diagrams:

* [Project 1: Morse Code](https://github.com/jwhitehorn/pi_piper/wiki/Project-1:-Morse-Code)
* [Project 2: Simple Switch](https://github.com/jwhitehorn/pi_piper/wiki/Project-2:-Simple-Switch)

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
