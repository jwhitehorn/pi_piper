module PiPiper
  class Pin
    attr_reader :pin, :last_value, :direction
    
    def initialize(options)
      @pin = options[:pin]
      @direction = options[:direction].nil? ? :in : options[:direction]
      
      File.open("/sys/class/gpio/export", "w") { |f| f.write("#{@pin}") }
      File.open("/sys/class/gpio/gpio#{pin}/direction", "w") { |f| f.write(@direction == :out ? "out" : "in") }
      
      @last_value = value
    end
    
    def on
      File.open(filename, 'w') {|f| f.write("1") }
    end
    
    def on?
      value == 1
    end
    
    def off
      File.open(filename, 'w') {|f| f.write("0") }
    end
    
    def off?
      value == 0
    end
    
    def changed?
      last_value != value
    end
    
    def value
      File.read(filename).to_i
    end
    
    private
    def filename
      "/sys/class/gpio/gpio#{pin}/value"
    end
  
  end
end
