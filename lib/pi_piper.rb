require 'gpio'

class PiPiper

  def self.watch(options)
    Thread.new do
      loop do
        sleep_time = options[:poll] || 0.1 
        pin = GPIO::InputPin.new(:pin => options[:pin])      
        until pin.changed? do sleep sleep_time end
        yield pin
      end 
    end.abort_on_exception = true  
  end

  def self.wait
    loop do sleep 1 end
  end

end
