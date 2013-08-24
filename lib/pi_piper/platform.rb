module PiPiper

  #Hardware abstraction manager. Not intended for direct use.
  class Platform

    #gets the current platform driver. Defaults to BCM2835.
    def self.driver
      @@driver ||= Bcm2835
    end

    def self.driver=(instance)
      @@driver = instance
    end

  end

end
