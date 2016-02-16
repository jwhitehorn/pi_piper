require_relative 'spec_helper'

describe 'Spi' do

  around(:example) do |example|
    Platform.driver = StubDriver.new.tap do |d|
        example.run
     end
  end

  describe 'when in block' do
    it 'should call spi_begin' do
      expect(Platform.driver).to receive(:spi_begin)
      Spi.begin {}
    end

    it 'should call spi_chip_select to set and unset chip' do
      expect(Platform.driver).to receive(:spi_chip_select).with(Spi::CHIP_SELECT_1)
      expect(Platform.driver).to receive(:spi_chip_select).with(Spi::CHIP_SELECT_NONE)

      Spi.begin(Spi::CHIP_SELECT_1) do
        read
      end
    end
  end

  describe 'set mode' do
    it 'should call spi_set_data_mode' do
      expect(Platform.driver).to receive(:spi_set_data_mode).with(Spi::SPI_MODE3)
      Spi.set_mode(1, 1)
    end
  end

  describe '#spidev_out' do
    it 'should attempt to write data to spi' do
      expect(Platform.driver).to receive(:spidev_out).with([0, 1, 2, 3, 4, 5])
      Spi.spidev_out([0, 1, 2, 3, 4, 5])
    end
  end
end
