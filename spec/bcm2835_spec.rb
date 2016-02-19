require 'spec_helper'
include PiPiper

describe 'Bcm2835' do
    let(:file_like_object) { double("file like object") }

    before(:example) do
      Platform.driver
      allow(File).to receive(:open).and_return(file_like_object)
      allow(File).to receive(:read).and_return("1")
    end

    it '#pin_input' do
      expect(Bcm2835).to receive(:export).with(4)
      expect(Bcm2835).to receive(:pin_direction).with(4, 'in')
      Bcm2835.pin_input(4)
    end
    
    it '#pin_output' do  
      expect(Bcm2835).to receive(:export).with(4)
      expect(Bcm2835).to receive(:pin_direction).with(4, 'out')
      Bcm2835.pin_output(4)
    end

    it '#pin_set' do
      expect(File).to receive(:open).with("/sys/class/gpio/gpio4/value", "w")
      Bcm2835.pin_set(4, 1)
    end

    it '#pin_read' do
      expect(File).to receive(:read).with("/sys/class/gpio/gpio4/value")
      Bcm2835.pin_read(4)
    end
    
    it '#pin_direction' do
      expect(File).to receive(:open).with("/sys/class/gpio/gpio4/direction", "w")
      Bcm2835.pin_direction(4, 'in')
    end

    it '#export' do
      expect(File).to receive(:open).with("/sys/class/gpio/export", "w")
      Bcm2835.export(4)
    end

    it '#release_pin' do
      expect(File).to receive(:open).with("/sys/class/gpio/unexport", "w")
      Bcm2835.release_pin(4)
    end
    
    it 'release_pins' do
    end
    
    xit 'spidev_out(array)' do
    end
    
    xit 'i2c_allowed_clocks' do
    end
    
    xit 'spi_transfer_bytes(data)' do
    end
    
    xit 'i2c_transfer_bytes(data)' do
    end

    xit 'i2c_read_bytes(bytes'do
    end
end

