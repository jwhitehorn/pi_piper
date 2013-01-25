Dir[File.dirname(__FILE__) + '/pi_piper/*.rb'].each {|file| require file }
at_exit do 
  PiPiper::Bcm2835.close
end 
PiPiper::Bcm2835.init

module PiPiper

  #Defines an event block to be executed when an pin event occurs.
  #
  # == Parameters:
  # options:
  #   Options hash. Options include `:pin`, `:invert` and `:trigger`.
  # 
  def PiPiper.watch(options)
    Thread.new do
      pin = PiPiper::Pin.new(options, &block)
      loop do
        pin.wait_for_change 
        pin.instance_eval { block.call pin } 
        #yield pin
      end 
    end.abort_on_exception = true  
  end

  #Prevents the main thread from exiting. Required when using PiPiper.watch
  def PiPiper.wait
    loop do sleep 1 end
  end

end
