module PiPiper

  #Hardware abstraction manager. Not intended for direct use.
  class Platform

    #gets the current platform driver. Defaults to BCM2835.
    def self.driver
      unless @@driver
        require 'bcm2835.rb'
        PiPiper::Bcm2835.init
        @@driver = PiPiper::Bcm2835
        at_exit { PiPiper::Bcm2835.close }
      end
      @@driver
    end

    def self.driver=(instance)
      @@driver = instance
    end

  end

end
