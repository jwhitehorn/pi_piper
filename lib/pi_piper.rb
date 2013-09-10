require 'eventmachine'
Dir[File.dirname(__FILE__) + '/pi_piper/*.rb'].each {|file| require file }#unless file.end_with?('bcm2835.rb') }

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
          block.call pin
        else
          pin.instance_exec &block
        end
      end 
    end.abort_on_exception = true  
  end
  
  #Defines an event block to be executed after a pin either goes high or low.
  #
  # @param [Hash] options A hash of options
  # @option options [Fixnum] :pin The pin number to initialize. Required.
  # @option options [Symbol] :goes The event to watch for. Either :high or :low. Required.
  def after(options, &block)
    options[:trigger] = options.delete(:goes) == :high ? :rising : :falling
    watch options, &block
  end
  
  #Defines an event block to be called on a regular schedule. The block will be passed the slave output.
  #
  # @param [Hash] options A hash of options.
  # @option options [Fixnum] :every A frequency of time (in seconds) to poll the SPI slave.
  # @option options [Fixnum] :slave The slave number to poll.
  # @option options [Number|Array] :write Data to poll the SPI slave with. 
  def poll_spi(options, &block)
    EM::PeriodicTimer.new(options[:every]) do
      Spi.begin options[:slave] do
        output = write options[:write]
        block.call output
      end
    end
  end
  
  #Defines an event block to be called when SPI slave output meets certain characteristics. 
  #The block will be passed the slave output.
  #
  # @param [Hash] options A hash of options.
  # @option options [Fixnum] :every A frequency of time (in seconds) to poll the SPI slave.
  # @option options [Fixnum] :slave The slave number to poll.
  # @option options [Number|Array] :write Data to poll the SPI slave with. 
  # @option options [Fixnum] :eq Tests for SPI slave output equality.
  # @option options [Fixnum] :lt Tests for SPI slave output less than supplied value.
  # @option options [Fixnum] :gt Tests for SPI slave output greater than supplied value.
  def when_spi(options, &block)
    poll_spi options do |value|
      if (options[:eq] && value == options[:eq]) || 
         (options[:lt] && value < options[:lt])  ||
         (options[:gt] && value > options[:gt])
          block.call value
      end
    end
  end

  #Prevents the main thread from exiting. Required when using PiPiper.watch
  # @deprecated Please use EventMachine.run instead
  def wait
    loop do sleep 1 end
  end

end
