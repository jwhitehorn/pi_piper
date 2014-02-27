# @description driver that can be used either with tests or with rails or other frameworks for development
require_relative 'pin_values'

module PiPiper

  class NullLogger
    def debug(*) end
  end

  module StubDriver
    include PiPiper::PinValues
    extend self

    def new(options = {})
      opts = {
          :logger => NullLogger.new
      }.merge(options)

      @logger = opts[:logger]

      @pins = {}
      @spi = {data:[], chip_select:0,}

      self
    end
    alias_method :reset, :new

    def pin_input(pin_number)
      pin(pin_number)[:direction] = :in
      @logger.debug("Pin ##{pin_number} -> Input")
    end

    def pin_output(pin_number)
      pin(pin_number)[:direction] = :out
      @logger.debug("Pin ##{pin_number} -> Output")
    end

    def pin_direction(pin_number)
      pin(pin_number)[:direction] if @pins[pin_number]
    end

    def pin_set(pin_number, value)
      pin(pin_number)[:value] = value
      @logger.debug("Pin ##{pin_number} -> #{value}")
    end

    def pin_set_pud(pin_number, value)
      pin(pin_number)[:pud] = value
      @logger.debug("PinPUD ##{pin_number} -> #{value}")
    end

    def spidev_out(array)
      @spi[:data] = array
      @logger.debug("SPIDEV -> #{array.pack('C*')}")
    end

    def spi_begin
      @logger.debug("SPI Begin")
      @spi[:data] = []
    end

    def spi_transfer_bytes(data)
      @logger.debug("SPI CS#{@spi[:chip_select]} <- #{data.to_s}")
      @spi[:data] = Array(data)
    end

    def spi_chip_select(chip = nil)
      chip = chip || @spi[:chip_select]
      @logger.debug("SPI Chip Select = #{chip}")
      @spi[:chip_select] = chip
    end


    def pin_read(pin_number)
      val = pin(pin_number)[:value]
      val ||= case pin(pin_number)[:pud]
                when GPIO_PUD_UP   then GPIO_HIGH
                when GPIO_PUD_DOWN then GPIO_LOW
                else nil
              end
    end

    def method_missing(meth, *args, &block)
      puts("Needs Implementation: StubDriver##{meth}")
    end

    private

      def pin(pin_number)
        @pins[pin_number] || (@pins[pin_number] = {})
      end

    ## The following methods are only for testing and are not available on any platforms
      def spi_data
        @spi[:data]
      end

  end
end
