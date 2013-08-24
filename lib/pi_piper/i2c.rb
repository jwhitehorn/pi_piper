module PiPiper

  #I2C support
  class I2C

    def initialize
      Bcm2835.i2c_begin
    end

    def end
      Bcm2835.i2c_end
    end

  end

end
