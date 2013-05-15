module PiPiper
  # Represents a GPIO pin on the Raspberry Pi
  class Pin
    GPIO_PUD_OFF = 0
    GPIO_PUD_DOWN = 1
    GPIO_PUD_UP = 2

    attr_reader :pin, :last_value, :value, :direction, :invert

    #Initializes a new GPIO pin.
    #
    # @param [Hash] options A hash of options
    # @option options [Fixnum] :pin The pin number to initialize. Required.
    # @option options [Symbol] :direction The direction of communication, either :in or :out. Defaults to :in.
    # @option options [Boolean] :invert Indicates if the value read from the physical pin should be inverted. Defaults to false.
    # @option options [Symbol] :trigger Indicates when the wait_for_change method will detect a change, either :rising, :falling, or :both edge triggers. Defaults to :both.
    # @option options [Symbol] :pull Indicates if and how pull mode must be set when pin direction is set to :in. Either :up, :down or :offing. Defaults to :off.
    def initialize(options)
      options = {:direction => :in, :invert => false, :trigger => :both, :pull => nil}.merge options
      @pin = options[:pin]
      @direction = options[:direction]
      @invert = options[:invert]
      @trigger = options[:trigger]
      @pull = options[:pull]

      raise "Invalid pull mode. Options are :up, :down or :float (default)" unless [:up, :down, :float, :off].include? @pull
      raise "Unable to use pull-ups : pin direction must be ':in' for this" if @direction != :in && [:up, :down].include?(@pull)
      raise "Invalid direction. Options are :in or :out" unless [:in, :out].include? @direction
      raise "Invalid trigger. Options are :rising, :falling, or :both" unless [:rising, :falling, :both].include? @trigger

      File.open("/sys/class/gpio/export", "w") { |f| f.write("#{@pin}") }
      File.open(direction_file, "w") { |f| f.write(@direction == :out ? "out" : "in") }

      pull!(options[:pull])

      read
    end
    
    # If the pin has been initialized for output this method will set the logic level high.
    def on
      File.open(value_file, 'w') {|f| f.write("1") } if direction == :out
    end
    
    # Tests if the logic level is high.
    def on?
      not off?
    end
    
    # If the pin has been initialized for output this method will set the logic level low.
    def off
      File.open(value_file, 'w') {|f| f.write("0") } if direction == :out
    end
    
    # Tests if the logic level is low.
    def off?
      value == 0
    end

    # If the pin has been initialized for output this method will either raise or lower the logic level depending on `new_value`.
    # @param [Object] new_value If false or 0 the pin will be set to off, otherwise on.
    def update_value(new_value)
      !new_value || new_value == 0 ? off : on
    end

    # When the pin has been initialized in input mode, internal resistors can be pulled up or down (respectively with :up and :down).
    # Pulling an input pin wil prevent noise from triggering it when the input is floating. 
    # For instance when nothing is plugged in, pulling the pin-up will make subsequent value readings to return 'on' (or high, or 1...).
    # @param [Symbol] state Indicates if and how pull mode must be set when pin direction is set to :in. Either :up, :down or :offing. Defaults to :off.
    def pull!(state)
      return nil unless @direction == :in
      @pull = case state
              when :up then GPIO_PUD_UP
              when :down then GPIO_PUD_DOWN
              # :float and :off are just aliases
              when :float, :off then GPIO_PUD_OFF
              else nil
              end

      Bcm2835.pin_set_pud(@pin, @pull) if @pull
      @pull
    end

    # If the pin direction is input, it will return the current state of pull-up/pull-down resistor, either :up, :down or :off.
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

    # blocks until a logic level change occurs. The initializer option `:trigger` modifies what edge this method will release on.
    def wait_for_change
      fd = File.open(value_file, "r")
      File.open(edge_file, "w") { |f| f.write("both") }
      loop do
        fd.read
        IO.select(nil, nil, [fd], nil)
        read 
        if changed?
          next if @trigger == :rising and value == 0
          next if @trigger == :falling and value == 1
          break
        end
      end
    end

    # Reads the current value from the pin. Without calling this method first, `value`, `last_value` and `changed?` will not be updated. 
    # In short, you must call this method if you are curious about the current state of the pin.
    def read 
      @last_value = @value
      val = File.read(value_file).to_i
      @value = invert ? (val ^ 1) : val
    end
    
    private
    def value_file
      "/sys/class/gpio/gpio#{pin}/value"
    end

    def edge_file
      "/sys/class/gpio/gpio#{pin}/edge"
    end

    def direction_file
      "/sys/class/gpio/gpio#{pin}/direction"
    end
  
  end
end
