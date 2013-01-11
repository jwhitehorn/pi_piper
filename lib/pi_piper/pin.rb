module PiPiper
  class Pin
    attr_reader :pin, :last_value
    
    def initialize(options)
      @pin = options[:pin]
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
