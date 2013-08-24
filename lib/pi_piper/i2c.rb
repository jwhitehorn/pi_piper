module PiPiper

  #I2C support
  class I2C

    def initialize
      Bcm2835.i2c_begin
    end

  end

end
