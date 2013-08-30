module PiPiper

  #I2C support
  class I2C

#http://www.airspayce.com/mikem/bcm2835/group__i2c.html

    def initialize
      Platform.driver.i2c_begin
    end

    def end
      Platform.driver.i2c_end
    end

    def self.begin(&block)
      instance = I2C.new
      begin
        if block.arity > 0
          block.call instance
        else
          instance.instance_exec &block 
        end
      ensure
        instance.end
      end
    end

    def self.clock=(clock)
      valid_clocks = Platform.driver.i2c_allowed_clocks

      raise "Invalid clock rate. Valid clocks are 100 kHz, 399.3610 kHz, 1.666 MHz and 1.689 MHz" unless valid_clocks.include? clock

      Platform.driver.i2c_set_clock clock
    end

    def write(params)
      data = params[:data]
      address = params[:to]

      raise ":data must be enumerable" unless data.class.include? Enumerable
      Platform.driver.i2c_set_address address
      Platform.driver.i2c_transfer_bytes data
    end

  end

end
