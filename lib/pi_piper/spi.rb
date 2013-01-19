=begin
Modifications Copyright 2013, Jason Whitehorn and released under the terms
of the license included in README.md

Based on works, Copyright (c) 2012 Joshua Nussbaum

MIT License

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
=end

module PiPiper
  class Spi
    # 65536 = 256us = 4kHz
    CLOCK_DIVIDER_65536 = 0
    # 32768 = 126us = 8kHz
    CLOCK_DIVIDER_32768 = 32768
    # 16384 = 64us = 15.625kHz
    CLOCK_DIVIDER_16384 = 16384
    # 8192 = 32us = 31.25kHz
    CLOCK_DIVIDER_8192  = 8192
    # 4096 = 16us = 62.5kHz
    CLOCK_DIVIDER_4096  = 4096
    # 2048 = 8us = 125kHz
    CLOCK_DIVIDER_2048  = 2048
    # 1024 = 4us = 250kHz
    CLOCK_DIVIDER_1024  = 1024
    # 512 = 2us = 500kHz
    CLOCK_DIVIDER_512   = 512
    # 256 = 1us = 1MHz
    CLOCK_DIVIDER_256   = 256
    # 128 = 500ns = = 2MHz
    CLOCK_DIVIDER_128   = 128
    # 64 = 250ns = 4MHz
    CLOCK_DIVIDER_64    = 64
    # 32 = 125ns = 8MHz
    CLOCK_DIVIDER_32    = 32
    # 16 = 50ns = 20MHz
    CLOCK_DIVIDER_16    = 16

    # Least signifigant bit first, e.g. 4 = 0b001
    LSBFIRST = 0
    # Most signifigant bit first, e.g. 4 = 0b100
    MSBFIRST = 1

    # Select Chip 0
    CHIP_SELECT_0 = 0
    # Select Chip 1
    CHIP_SELECT_1 = 1
    # Select both chips (ie pins CS1 and CS2 are asserted)
    CHIP_SELECT_BOTH = 2
    # No CS, control it yourself
    CHIP_SELECT_NONE = 3

    # Initializes SPI, must be called before SPI can be used
    #
    # @example With a block
    #   SPI.begin do |spi| 
    #     spi.write 1
    #   end
    #
    # @example Without a block
    #   spi = SPI.begin
    #   spi.write 1
    #   spi.end # must call end yourself
    #
    # @example Specifying the chip select line
    #   SPI.begin(SPI::CHIP_SELECT_1) do |spi|
    #     spi.write 1
    #   end
    #
    # @yield [SPI] 
    # @param [optional, CHIP_SELECT_*] chip defaults to CHIP_SELECT_0
    # @return [SPI] 
    def self.begin(chip=nil)
      Bcm2835.spi_begin
      chip = CHIP_SELECT_0 if !chip && block_given?
      spi = new(chip)

      if block_given?
        begin
          yield(spi)
        ensure
          self.end
        end
      else
        spi
      end
    end

    # Manually shut down SPI
    #
    # Not needed when #begin is called with a block
    def self.end
      Bcm2835.spi_end
    end

    # Configure the clock prescaler
    # 
    # Default is CLOCK_DIVIDER_65536 (4kHz)
    #
    # @example Run SPI at 2MHz
    #   spi.clock(SPI::CLOCK_DIVIDER_128)
    #
    # @param [CLOCK_DIVIDER_*] divider the value to prescale the clock by
    def clock(divider)
      Bcm2835.spi_clock(divider)
    end

    # Configure the order that bits are sent and received from the bus
    #
    # @example Most signifigant bit first
    #   spi.bit_order(7..0)
    #   # or
    #   spi.bit_order(SPI::MSBFIRST)
    #
    # @example Least signifigant bit first
    #   spi.bit_order(0..7)
    #   # or
    #   spi.bit_order(SPI::LSBFIRST)
    #
    # @param [Range|LSBFIRST|MSBFIRST] order
    def bit_order(order=MSBFIRST)
      if order.is_a?(Range)  
        if order.begin < order.end
          order = LSBFIRST
        else
          order = MSBFIRST
        end
      end

      Bcm2835.spi_bit_order(order)
    end

    # Activate a specific chip so that communication can begin
    #
    # When a block is provided, the chip is automatically deactivated after the block completes.
    # When a block is not provided, the user is responsible for calling chip_select(CHIP_SELECT_NONE) 
    #
    # @example With block (preferred)
    #   spi.chip_select do
    #     spi.write(0xFF)
    #   end
    #
    # @example Without block
    #   spi.chip_select(CHIP_SELECT_0)
    #   spi.write(0xFF)
    #   spi.write(0x22)
    #   spi.chip_select(CHIP_SELECT_NONE)
    #
    # @yield 
    # @param [optional, CHIP_SELECT_*] chip the chip select line options
    def chip_select(chip=CHIP_SELECT_0)
      chip = @chip if @chip 
      Bcm2835.spi_chip_select(chip) 
      if block_given?
        begin
          yield
        ensure
          Bcm2835.spi_chip_select(CHIP_SELECT_NONE)
        end
      end
    end

    # Configure the active state of the chip select line
    #
    # The default state for most chips is active low.
    #
    # "active low" means the clock line is kept high during idle, and goes low when communicating.
    #
    # "active high" means the clock line is kept low during idle, and goes high when communicating.
    #
    # @param [Boolean] active_low true for active low, false for active high 
    # @param [optional, CHIP_SELECT_*] chip one of CHIP_SELECT_*
    def chip_select_active_low(active_low, chip=nil)
      chip = @chip if @chip
      chip = CHIP_SELECT_0 unless chip

      Bcm2835.spi_chip_select_polarity(chip, active_low ? 0 : 1)
    end

    # Read from the bus
    #
    # @example Read a single byte
    #   byte = spi.read
    #
    # @example Read array of bytes
    #   array = spi.read(3)
    #
    #
    # @param [optional, Number] count the number of bytes to read. 
    #   When count is provided, an array is returned.
    #   When count is nil, a single byte is returned.
    # @return [Number|Array] data that was read from the bus
    def read(count=nil)
      if count
        write([0xFF] * count)
      else
        enable { Bcm2835.spi_transfer(0) }
      end
    end

    # Write to the bus
    #
    # @example Write a single byte
    #   spi.write(0x22)
    #
    # @example Write multiple bytes
    #   spi.write(0x22, 0x33, 0x44)
    #
    # @example Write a string
    #   spi.write("Hello SPI!")
    #
    # @example Write any enumerable
    #   spi.write(30..40)
    #
    # @return [Number|Array|String] data that came out of MISO during write
    def write(*args)
      case args.count
        when 0
          raise ArgumentError.new("missing arguments")
        when 1
          data = args.first
        else
          data = args
      end

      enable do
        case data
        when Numeric
          Bcm2835.spi_transfer(data)
        when String
          data.each_byte.map {|byte| Bcm2835.spi_transfer(byte).chr }.join 
        when Enumerable
          Bcm2835.spi_transfer_bytes(data)
        else
          raise ArgumentError.new("#{data.class} is not valid data. User Numeric, String or an Enumerable of numbers")
        end
      end
    end

  private
    def initialize(chip)
      @chip = chip
    end

    def enable(&block)
      if @chip
        chip_select(&block)
      else
        yield
      end
    end
  end
end
