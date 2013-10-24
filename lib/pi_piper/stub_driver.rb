# @description driver that can be used either with tests or with rails or other frameworks for development
require_relative 'pin_values'

module PiPiper::StubDriver
  include PiPiper::PinValues
  extend self

  def new(options = {})
    opts = {
        :logger => nil
    }.merge(options)

    @logger = opts[:logger]

    @pins = {}

    self
  end
  alias_method :reset, :new

  def pin_input(pin_number)
    pin(pin_number)[:direction] = :in
    @logger.debug("Pin ##{pin_number} -> Input") if @logger
  end

  def pin_output(pin_number)
    pin(pin_number)[:direction] = :out
    @logger.debug("Pin ##{pin_number} -> Output") if @logger
  end

  def pin_direction(pin_number)
    pin(pin_number)[:direction] if @pins[pin_number]
  end

  def pin_set(pin_number, value)
    pin(pin_number)[:value] = value
    @logger.debug("Pin ##{pin_number} -> #{value}") if @logger
  end

  def pin_set_pud(pin_number, value)
    pin(pin_number)[:pud] = value
    @logger.debug("PinPUD ##{pin_number} -> #{value}") if @logger
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


end