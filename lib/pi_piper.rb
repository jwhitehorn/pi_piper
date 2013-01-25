Dir[File.dirname(__FILE__) + '/pi_piper/*.rb'].each {|file| require file }
at_exit do 
  PiPiper::Bcm2835.close
end 
PiPiper::Bcm2835.init

module PiPiper
  extend self
  
  #Defines an event block to be executed when an pin event occurs.
  #
  # == Parameters:
  # options:
  #   Options hash. Options include `:pin`, `:invert` and `:trigger`.
  # 
  def watch(options, &block)
    Thread.new do
      pin = PiPiper::Pin.new(options)
      loop do
        pin.wait_for_change 
        if block.arity > 0
          pin.instance_exec &block
        else
          block.call pin
        end
      end 
    end.abort_on_exception = true  
  end

  #Prevents the main thread from exiting. Required when using PiPiper.watch
  def wait
    loop do sleep 1 end
  end

end
