module PiPiper
  # Represents a Pwm output on the Raspberry Pi (only GPIO18 is avaliable on header)
  class Pwm

    attr_reader :value, :options
    
    # Initializes a new PWM pin.
    #
    # @param [Hash] options A hash of options
    # @option options [Fixnum] :pin The pin number to initialize. Required.
    # 
    # @option options [Symbol] :mode The modulation's mode, 
    # either :balanced or :markspace but depends from driver. Defaults to :balanced.
    # 
    # @option options [Fixnum] :clock Indicates the internal clock of the signal.
    # Defaults to 19.2Mhz.
    # 
    # @option options [Fixnum] :range Indicates the number of step allowed 
    # for the value. Defaults to 1024.
    # 
    # @option options [Fixnum] :value Indicates the value at_start. 
    # Defaults to 0.
    #
    def initialize(options)
      @options = {
        :mode => :balanced,
        :clock => 19.2.megahertz,
        :range => 1024,
        :value => 0,
      }.merge(options)
      
      PiPiper.driver.pwm_set_pin(@options[:pin])
      PiPiper.driver.pwm_set_clock(get_clock_divider(@options[:clock]))
      PiPiper.driver.pwm_set_range(@options[:pin], options[:range])
      
      self.value= @options.delete(:value)

      PiPiper.driver.pwm_set_mode(@options[:pin], options[:mode])
      
    end

    # Start the Pwm signal
    # 
    def on
      @on = true
      PiPiper.driver.pwm_set_mode(@options[:pin], options[:mode], 1) #check if compatible with other driver than bcm2835
    end
    
    alias :start :on

    # Stop the Pwm signal
    # 
    def off
      @on = false
      PiPiper.driver.pwm_set_mode(@options[:pin], options[:mode], 0) #check if compatible with other driver than bcm2835
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
      PiPiper.driver.pwm_set_data(@options[:pin], data(@value))
    end

    private

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
