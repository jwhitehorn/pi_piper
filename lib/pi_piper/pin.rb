require_relative 'pin_values'

module PiPiper
  # Represents a GPIO pin on the Raspberry Pi
  class Pin
    include PiPiper::PinValues

    attr_reader :pin, :last_value, :direction, :invert

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
    # set when pin direction is set to :in. Either :up, :down or :offing. 
    # Defaults to :off.
    #
    def initialize(options)
      options = { :direction => :in,
                  :invert => false,
                  :trigger => :both,
                  :pull => :off }.merge(options)

      @pin       = options[:pin]
      @direction = options[:direction]
      @invert    = options[:invert]
      @trigger   = options[:trigger]
      @pull      = options[:pull]

      raise ArgumentError, 'Pin # required' unless @pin
      unless valid_pull?
        raise PiPiper::PinError, 'Invalid pull mode. Options are :up, :down or :float (default)'
      end
      unless valid_direction?
        raise PiPiper::PinError, 'Invalid direction. Options are :in or :out'
      end
      if @direction != :in && [:up, :down].include?(@pull)
        raise PiPiper::PinError, 'Unable to use pull-ups : pin direction must be :in for this'
      end
      unless valid_trigger?
        raise PiPiper::PinError, 'Invalid trigger. Options are :rising, :falling, or :both'
      end

      if @direction == :out
        Platform.driver.pin_output(@pin)
      else
        Platform.driver.pin_input(@pin)
      end
      pull!(@pull)

      read
    end

    # If the pin has been initialized for output this method will set the 
    # logic level high.
    def on
      Platform.driver.pin_set(pin, GPIO_HIGH) if direction == :out
    end

    # Tests if the logic level is high.
    def on?
      not off?
    end

    # If the pin has been initialized for output this method will set 
    # the logic level low.
    def off
      Platform.driver.pin_set(pin, GPIO_LOW) if direction == :out
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

    # When the pin has been initialized in input mode, internal resistors can 
    # be pulled up or down (respectively with :up and :down).
    # 
    # Pulling an input pin will prevent noise from triggering it when the input
    # is floating.
    # 
    # For instance when nothing is plugged in, pulling the pin-up will make 
    # subsequent value readings to return 'on' (or high, or 1...).
    # @param [Symbol] state Indicates if and how pull mode must be set when 
    # pin direction is set to :in. Either :up, :down or :offing. Defaults to :off.
    def pull!(state)
     raise PiPiper::PinError, "Unable to use pull-ups : pin direction must be ':in' for this" if 
        @direction != :in and [:up, :down].include?(state)
      @pull = case state
              when :up then GPIO_PUD_UP
              when :down then GPIO_PUD_DOWN
              # :float and :off are just aliases
              when :float, :off then GPIO_PUD_OFF
              else nil
              end

      Platform.driver.pin_set_pud(@pin, @pull) if @pull
      @pull
    end

    # If the pin direction is input, it will return the current state of 
    # pull-up/pull-down resistor, either :up, :down or :off.
    def pull?
      case @pull
      when GPIO_PUD_UP then :up
      when GPIO_PUD_DOWN then :down
      else :off
      end
    end

    # Tests if the logic level has changed since the pin was last read.
    def changed?
      last_value != value
    end

    # Blocks until a logic level change occurs. The initializer option 
    # `:trigger` modifies what edge this method will release on.
    def wait_for_change
      Platform.driver.pin_wait_for(@pin, @trigger)
    end
    
    # Reads the current value from the pin. Without calling this method 
    # first, `value`, `last_value` and `changed?` will not be updated.
    # 
    # In short, you must call this method if you are curious about the 
    # current state of the pin.
    def read
      val = Platform.driver.pin_read(@pin)
      @last_value = @value
      @value = invert ? (val ^ 1) : val
    end

  private
    def method_missing(method, *args, &block)
      Platform.driver.send(method, @pin, *args, &block)
		end
		
    def valid_trigger?
      [:rising, :falling, :both].include?(@trigger)
    end

    def valid_direction?
      [:in, :out].include?(@direction)
    end

    def valid_pull?
      [:up, :down, :float, :off].include? @pull
    end
  end
end
