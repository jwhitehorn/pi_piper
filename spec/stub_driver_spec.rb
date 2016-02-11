require 'spec_helper'

describe StubDriver do
  let(:stub_driver) { StubDriver.new }

  before do
    @logger = double
    @driver = StubDriver.new(logger: @logger)
  end

  describe '#pin_input' do
    it 'should set pin as input' do
      stub_driver.pin_input(10)
      expect(stub_driver.pin_direction(10)).to eq(:in)
    end

    it 'should log that pin is set' do
      expect(@logger).to receive(:debug).with('Pin #10 -> Input')
      @driver.pin_input(10)
    end
  end

  describe '#pin_output' do
    it 'should set pin as output' do
      stub_driver.pin_output(10)
      expect(stub_driver.pin_direction(10)).to eq(:out)
    end

    it 'should log that pin is set' do
      expect(@logger).to receive(:debug).with('Pin #10 -> Output')
      @driver.pin_output(10)
    end
  end

  describe '#pin_set' do
    it 'should set pin value' do
      stub_driver.pin_set(22, 42)
      expect(stub_driver.pin_read(22)).to eq(42)
    end

    it 'should log the new pin value' do
      expect(@logger).to receive(:debug).with('Pin #21 -> 22')
      @driver.pin_set(21, 22)
    end
  end

  describe '#pin_set_pud' do
    it 'should set pin value' do
      stub_driver.pin_set_pud(12, Pin::GPIO_PUD_UP)
      expect(stub_driver.pin_read(12)).to eq(Pin::GPIO_HIGH)
    end

    it 'should not overwrite set value' do
      stub_driver.pin_set(12, 0)
      stub_driver.pin_set_pud(12, Pin::GPIO_PUD_DOWN)
      expect(stub_driver.pin_read(12)).to eq(Pin::GPIO_LOW)
    end

    it 'should log the new pin value' do
      expect(@logger).to receive(:debug).with('PinPUD #21 -> 22')
      @driver.pin_set_pud(21, 22)
    end
  end

  describe '#spidev_out' do
    it 'should log the array sent to ada_spi_out' do
      expect(@logger).to receive(:debug).with("SPIDEV -> \u0000\u0001\u0002")
      @driver.spidev_out([0x00, 0x01, 0x02])
    end
  end

  describe '#spi_begin' do
    it 'should should clear spi data' do
      expect(@logger).to receive(:debug)
      @driver.spi_transfer_bytes([0x01, 0x02])
      expect(@logger).to receive(:debug).with('SPI Begin')
      @driver.spi_begin
      expect(@driver.send(:spi_data)).to eq([])
    end
  end

  describe '#spi_transfer_bytes' do
    it 'should log and store sent data' do
      expect(@logger).to receive(:debug).with('SPI CS0 <- [1, 2, 3]')
      @driver.spi_transfer_bytes([0x01, 0x02, 0x03])
      expect(@driver.send(:spi_data)).to eq([0x01, 0x02, 0x03])
    end
  end

  describe '#spi_chip_select' do
    it 'should return default 0 if nothing provided' do
      expect(@logger).to receive(:debug).with('SPI Chip Select = 0')
      expect(@driver.spi_chip_select).to eq(0)
    end

    it 'should set chip select value if passed in' do
      expect(@logger).to receive(:debug).with('SPI Chip Select = 3').twice
      @driver.spi_chip_select(3)
      expect(@driver.spi_chip_select).to eq(3)
    end
  end

  describe '#reset' do
    it 'should not reset unless asked' do
      StubDriver.new()
      StubDriver.pin_set(1,3)
      expect(StubDriver.pin_read(1)).to eq(3)
      StubDriver.reset
      expect(StubDriver.pin_read(1)).to be_nil
    end
  end

  describe '#release_pins' do
    before(:each) do
      StubDriver.new
      StubDriver.pin_input(4)
      StubDriver.pin_output(6)
    end

    it 'should keep track of open pins and release them' do
      expect(@driver).to receive(:release_pin).with(4)
      expect(@driver).to receive(:release_pin).with(6)

      StubDriver.release_pins
    end

    it 'should remove released pins' do
      StubDriver.release_pins

      expect(StubDriver.pin_direction(4)).to be_nil
      expect(StubDriver.pin_direction(6)).to be_nil
    end

    it 'should keep track of released pins' do
      StubDriver.release_pins
      expect(@driver).not_to receive(:release_pin)
      StubDriver.release_pins
    end
  end
end
