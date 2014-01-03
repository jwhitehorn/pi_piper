#--
#Modifications Copyright 2013, Jason Whitehorn and released under the terms
#of the license included in README.md
#
#Based on works, Copyright (c) 2012 Joshua Nussbaum
#
#MIT License
#
#Permission is hereby granted, free of charge, to any person obtaining
#a copy of this software and associated documentation files (the
#"Software"), to deal in the Software without restriction, including
#without limitation the rights to use, copy, modify, merge, publish,
#distribute, sublicense, and/or sell copies of the Software, and to
#
#permit persons to whom the Software is furnished to do so, subject to
#the following conditions:
#
#The above copyright notice and this permission notice shall be
#included in all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
#EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
#MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
#NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
#OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
#WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++





module PiPiper
  # class for SPI interfaces on the Raspberry Pi
  class Spi
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

    # SPI Modes
    SPI_MODE0 = 0
    SPI_MODE1 = 1
    SPI_MODE2 = 2
    SPI_MODE3 = 3 

    #Sets the SPI mode. Defaults to mode (0,0).
    def self.set_mode(cpol, cpha)
      mode = SPI_MODE0 #default
      mode = SPI_MODE1 if cpol == 0 and cpha == 1
      mode = SPI_MODE2 if cpol == 1 and cpha == 0
      mode = SPI_MODE3 if cpol == 1 and cpha == 1
      Platform.driver.spi_set_data_mode mode
    end

    #Begin an SPI block. All SPI communications should be wrapped in a block.
    def self.begin(chip=nil, &block)
      Platform.driver.spi_begin
      chip = CHIP_SELECT_0 if !chip && block_given?
      spi = new(chip)

      if block.arity > 0
        block.call spi
      else  
        spi.instance_exec &block
      end
    end

    # Not needed when #begin is called with a block
    def self.end
      Platform.driver.spi_end
    end

    # Sets the SPI clock frequency
    def clock(frequency)
      options = {4000     => 0,      #4 kHz
                 8000     => 32768,  #8 kHz
                 15625    => 16384,  #15.625 kHz
                 31250    => 8192,   #31.25 kHz
                 62500    => 4096,   #62.5 kHz
                 125000   => 2048,   #125 kHz
                 250000   => 1024,   #250 kHz
                 500000   => 512,    #500 kHz
                 1000000  => 256,    #1 MHz
                 2000000  => 128,    #2 MHz
                 4000000  => 64,     #4 MHz
                 8000000  => 32,     #8 MHz
                 20000000 => 16      #20 MHz
               }
      divider = options[frequency]
      Platform.driver.spi_clock(divider)
    end

    def bit_order(order=MSBFIRST)
      if order.is_a?(Range)  
        if order.begin < order.end
          order = LSBFIRST
        else
          order = MSBFIRST
        end
      end

      Platform.driver.spi_bit_order(order)
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
      Platform.driver.spi_chip_select(chip) 
      if block_given?
        begin
          yield
        ensure
          Platform.driver.spi_chip_select(CHIP_SELECT_NONE)
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

      Platform.driver.spi_chip_select_polarity(chip, active_low ? 0 : 1)
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
        enable { Platform.driver.spi_transfer(0) }
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
    # @return [Number|Array] data that came out of MISO during write
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
          Platform.driver.spi_transfer(data)
        when Enumerable
          Platform.driver.spi_transfer_bytes(data)
        else
          raise ArgumentError.new("#{data.class} is not valid data. Use Numeric or an Enumerable of numbers")
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
