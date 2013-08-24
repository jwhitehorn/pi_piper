module PiPiper

  #I2C support
  class I2C

#http://www.airspayce.com/mikem/bcm2835/group__i2c.html

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
      instance.end
    end

    def write(*args)
      case args.count
        when 0
          raise ArgumentError.new("missing arguments")
        when 1
          data = args.first
        else
          data = args
      end

      raise "not implemented yet" unless data.class.include? Enumerable
      Bcm2835.i2c_transfer_bytes data
    end

  end

end
