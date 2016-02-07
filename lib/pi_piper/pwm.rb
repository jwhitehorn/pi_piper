require_relative 'pin_values'

module PiPiper
  # Represents a Pwm output on the Raspberry Pi (only GPIO18 is avaliable on header)
  class Pwm
    include PiPiper::PinValues

    attr_reader :pin, :value, :options
    #Initializes a new PWM pin.
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

      raise ArgumentError, ":pin should be one of  #{PWM_PIN.keys} not #{@options[:pin]}" unless PWM_PIN[@options[:pin]]
      raise ArgumentError, ":mode should be one of #{PWM_MODE}, not #{@options[:mode]}" unless PWM_MODE.include? @options[:mode]

      self.pin= @options.delete(:pin)
      self.value= @options.delete(:value)

      Platform.driver.pwm_clock( get_clock_divider(@options[:clock]) )
      Platform.driver.pwm_range( PWM_PIN[@pin][:channel], @options[:range] )

      Platform.driver.pwm_mode(PWM_PIN[@pin][:channel], PWM_MODE.index(@options[:mode]), @options.delete(:start) ? 1 : 0)
    end

    # Start the Pwm signal 
    def on
      @on = true
      Platform.driver.pwm_mode(PWM_PIN[@pin][:channel], PWM_MODE.index(options[:mode]), 1)
    end

    alias :start :on
    # Stop the Pwm signal 
    def off
      @on = false
      Platform.driver.pwm_mode(PWM_PIN[@pin][:channel], PWM_MODE.index(options[:mode]), 0)
    end
    alias :stop :off

    def on?
      @on
    end

    def off?
      not on?
    end

    def value= (new_value)
      @value = sanitize_value(new_value)
      Platform.driver.pwm_data(PWM_PIN[@pin][:channel], data(@value))
    end

    private

    def pin= (bcm_number)
      @pin = bcm_number
      Platform.driver.gpio_select_function(@pin, PWM_PIN[@pin][:alt_fun])
    end

    def get_clock_divider(clock)
      (19.2.megahertz / clock).to_i
    end

    def data(sanitized_value)
      (sanitized_value * @options[:range]).to_i
    end

    def sanitize_value(raw_value)
      [0, [raw_value, 1].min ].max
    end
  end
end
