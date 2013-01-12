module PiPiper
  class Pin
    attr_reader :pin, :last_value, :direction, :invert
    
    def initialize(options)
      @pin = options[:pin]
      @direction = options[:direction].nil? ? :in : options[:direction]
      @invert = options[:invert].nil? ? false : options[:invert]
     
      File.open("/sys/class/gpio/export", "w") { |f| f.write("#{@pin}") }
      File.open("/sys/class/gpio/gpio#{pin}/direction", "w") { |f| f.write(@direction == :out ? "out" : "in") }
      
      @last_value = value
    end
    
    def on
      File.open(filename, 'w') {|f| f.write("1") } if direction == :out
    end
    
    def on?
      value == 1
    end
    
    def off
      File.open(filename, 'w') {|f| f.write("0") } if direction == :out
    end
    
    def off?
      value == 0
    end
    
    def changed?
      last_value != value
    end

    def wait_for_change
      fd = File.open(filename, "r")
      File.open("/sys/class/gpio/gpio#{pin}/edge", "w") { |f| f.write("both") }
      fd.read
      IO.select(nil, nil, [fd], nil)
      true
    end
    
    def value
      val = File.read(filename).to_i
      invert ? (val ^ 1) : val
    end
    
    private
    def filename
      "/sys/class/gpio/gpio#{pin}/value"
    end
  
  end
end
