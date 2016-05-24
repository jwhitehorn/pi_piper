module PiPiper
  # Represents a GPIO pin on the Raspberry Pi
  class Pin
    GPIO_HIGH = 1
    GPIO_LOW  = 0

    attr_reader :pin, :last_value, :options

    #Initializes a new GPIO pin.
    #
    # @param [Hash] options A hash of options
    # @option options [Fixnum] :pin The pin number to initialize. Required.
    # 
    # @option options [Symbol] :direction The direction of communication, 
    # either :in or :out. Defaults to :in.
    # 
    # @option options [Boolean] :invert Indicates if the value read from the 
    # physical pin should be inverted. Defaults to false.
    # 
    # @option options [Symbol] :trigger Indicates when the wait_for_change 
    # method will detect a change, either :rising, :falling, or :both edge 
    # triggers. Defaults to :both.
    # 
    # @option options [Symbol] :pull Indicates if and how pull mode must be 
    # set when pin direction is set to :in. Either :up, :down or :off. 
    # Defaults to :off.
    #
    def initialize(options)
      @options = {:direction => :in,
                  :invert => false,
                  :trigger => :none,
                  :pull => :off,
                }.merge(options)

      raise ArgumentError, 'Pin # required' unless @options[:pin]

      PiPiper.driver.pin_direction(@options[:pin], @options[:direction])
      PiPiper.driver.pin_set_trigger(@options[:pin], @options[:trigger])
      if @options[:direction] == :out && @options[:pull] != :off
        raise ArgumentError, 'Unable to use pull-ups : pin direction must be :in for this'
      else
        PiPiper.driver.pin_set_pud(@options[:pin], @options[:pull])
      end
      read
    end

    # If the pin has been initialized for output this method will set the 
    # logic level high.
    def on
      PiPiper.driver.pin_write(@options[:pin], GPIO_HIGH) if @options[:direction] == :out
    end

    # Tests if the logic level is high.
    def on?
      not off?
    end

    # If the pin has been initialized for output this method will set 
    # the logic level low.
    def off
      PiPiper.driver.pin_write(@options[:pin], GPIO_LOW) if @options[:direction] == :out
    end

    # Tests if the logic level is low.
    def off?
      value == GPIO_LOW
    end

    def value
      @value ||= read
    end

    # If the pin has been initialized for output this method will either raise 
    # or lower the logic level depending on `new_value`.
    # @param [Object] new_value If false or 0 the pin will be set to off, otherwise on.
    def update_value(new_value)
      !new_value || new_value == GPIO_LOW ? off : on
    end
    alias_method :value=, :update_value

    # Tests if the logic level has changed since the pin was last read.
    def changed?
      last_value != value
    end

    # Blocks until a logic level change occurs. The initializer option 
    # `:trigger` modifies what edge this method will release on.
    def wait_for_change
      PiPiper.driver.pin_wait_for(@options[:pin])
    end
    
    # Reads the current value from the pin. Without calling this method 
    # first, `value`, `last_value` and `changed?` will not be updated.
    # 
    # In short, you must call this method if you are curious about the 
    # current state of the pin.
    def read
      val = PiPiper.driver.pin_read(@options[:pin])
      @last_value = @value
      @value = @options[:invert] ? (val ^ 1) : val
    end

  private
    def method_missing(method, *args, &block)
      PiPiper.driver.send(method, @options[:pin], *args, &block)
    end
  end
end
