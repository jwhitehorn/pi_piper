require_relative 'pin_values'

module PiPiper
  
  # Represents a Pwm output on the Raspberry Pi (only GPIO18 is avaliable on header)
  class Pwm
    include PiPiper::PinValues

    attr_reader :value, :options
    
    # Initializes a new PWM pin.
    #
    # @param [Hash] options A hash of options
    # @option options [Fixnum] :pin The pin number to initialize. Required.
    def initialize(options)
      @options = {
        :mode => :balanced,
        :clock => 19.2.megahertz,
        :range => 1024,
        :start => true,
        :value => 0
      }.merge(options)

      unless PWM_PIN[@options[:pin]]
        raise ArgumentError, ":pin should be one of  #{PWM_PIN.keys} not #{@options[:pin]}"
      end

      unless PWM_MODE.include? @options[:mode]
        raise ArgumentError, ":mode should be one of #{PWM_MODE}, not #{@options[:mode]}"
      end

      self.value= @options.delete(:value)
      self.pin=   @options[:pin]
      self.range= @options[:range]
      self.clock= @options[:clock]

      @options.delete(:start) ? self.on : self.off
    end

    # Start the Pwm signal
    def on
      @on = true
      Platform.driver.pwm_mode(PWM_PIN[@options[:pin]][:channel], PWM_MODE.index(options[:mode]), 1)
    end
    
    alias :start :on

    # Stop the Pwm signal
    def off
      @on = false
      Platform.driver.pwm_mode(PWM_PIN[@options[:pin]][:channel], PWM_MODE.index(options[:mode]), 0)
    end

    alias :stop :off

    def on?
      @on
    end

    def off?
      not on?
    end

    def value=(new_value)
      @value = sanitize_value(new_value)
      Platform.driver.pwm_data(PWM_PIN[@options[:pin]][:channel], data(@value))
    end

    def clock=(clock)
      Platform.driver.pwm_clock(get_clock_divider(clock))
    end
    
    private

    def range=(range)
      Platform.driver.pwm_range(PWM_PIN[@options[:pin]][:channel], range)
    end

    def pin=(bcm_pin_number)
      Platform.driver.gpio_select_function(bcm_pin_number, PWM_PIN[@options[:pin]][:alt_fun])
    end

    def get_clock_divider(clock)
      (19.2.megahertz.to_f / clock).to_i
    end

    def data(sanitized_value)
      (sanitized_value * @options[:range]).to_i
    end

    def sanitize_value(raw_value)
      [0, [raw_value, 1].min ].max
    end
  end
end
