Dir[File.dirname(__FILE__) + '/pi_piper/*.rb'].each {|file| require file }

module PiPiper

  def PiPiper.watch(options)
    Thread.new do
      loop do
        sleep_time = options[:poll] || 0.1 
        pin = PiPiper::Pin.new(:pin => options[:pin])      
        until pin.changed? do sleep sleep_time end
        yield pin
      end 
    end.abort_on_exception = true  
  end

  def PiPiper.wait
    loop do sleep 1 end
  end

end
