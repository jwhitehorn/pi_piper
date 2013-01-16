Dir[File.dirname(__FILE__) + '/pi_piper/*.rb'].each {|file| require file unless file.end_with?('bcm2835.rb') }

module PiPiper

  def PiPiper.watch(options)
    Thread.new do
      pin = PiPiper::Pin.new(options)
      loop do
        pin.wait_for_change 
        yield pin
      end 
    end.abort_on_exception = true  
  end

  def PiPiper.wait
    loop do sleep 1 end
  end

end
