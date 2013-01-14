module PiPiper
  class Pin
    attr_reader :pin, :last_value, :value, :direction, :invert
    
    def initialize(options)
      options = {:direction => :in, :invert => false, :trigger => :both}.merge options
      @pin = options[:pin]
      @direction = options[:direction]
      @invert = options[:invert]
      @trigger = options[:trigger]
     
      File.open("/sys/class/gpio/export", "w") { |f| f.write("#{@pin}") }
      File.open(direction_file, "w") { |f| f.write(@direction == :out ? "out" : "in") }
      
      read 
    end
    
    def on
      File.open(value_file, 'w') {|f| f.write("1") } if direction == :out
    end
    
    def on?
      not off?
    end
    
    def off
      File.open(value_file, 'w') {|f| f.write("0") } if direction == :out
    end
    
    def off?
      value == 0
    end

    def update_value(new_value)
      new_value ? on : off
    end
    
    def changed?
      last_value != value
    end

    def wait_for_change
      fd = File.open(value_file, "r")
      File.open(edge_file, "w") { |f| f.write("both") }
      loop do
        fd.read
        IO.select(nil, nil, [fd], nil)
        read 
        if changed?
          next if @trigger == :rising and value == 0
          next if @trigger == :failling and value == 1
          break
        end
      end
    end
    
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
