module PiPiper

  #I2C support
  class I2C

    def initialize
      Bcm2835.i2c_begin
    end

    def end
      Bcm2835.i2c_end
    end

    def self.begin(&block)
      instance = I2C.new
      if block.arity > 0
        block.call instance
      else
        instance.instance_exec &block 
      end
    end

  end

end
