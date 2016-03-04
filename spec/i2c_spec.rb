require_relative 'spec_helper'

describe PiPiper::I2C do

  before(:context) do
    PiPiper.driver = PiPiper::Driver
  end
  
  describe 'clock setting' do
    it 'should check driver settings' do
      expect(PiPiper.driver).to receive(:i2c_allowed_clocks).and_return([100.kilohertz])
      PiPiper::I2C.clock = 100.kilohertz
    end

    it 'should accept 100 kHz' do
      expect(PiPiper.driver).to receive(:i2c_allowed_clocks).and_return([100.kilohertz])
      expect(PiPiper.driver).to receive(:i2c_set_clock).with(100.kilohertz)
      PiPiper::I2C.clock = 100.kilohertz
    end

    it 'should not accept 200 kHz' do
      expect(PiPiper.driver).to receive(:i2c_allowed_clocks).and_return([100.kilohertz])
      expect { PiPiper::I2C.clock = 200.kilohertz }.to raise_error ArgumentError
    end
  end

  describe 'when in block' do
    it 'should call i2c_begin' do
      expect(PiPiper.driver).to receive(:i2c_begin)
      PiPiper::I2C.begin {}
    end

    it 'should call i2c_end' do
      expect(PiPiper.driver).to receive(:i2c_end)
      PiPiper::I2C.begin {}
    end

    it 'should call i2c_end even after raise' do
      expect(PiPiper.driver).to receive(:i2c_end)
      begin
        PiPiper::I2C.begin { raise 'OMG' }
      rescue
      end
    end

    describe 'write operation' do
      it 'should set address' do
        expect(PiPiper.driver).to receive(:i2c_set_address).with(4)
        PiPiper::I2C.begin do
          write to: 4, data: [1, 2, 3, 4]
        end
      end

      it 'should pass data to driver' do
        expect(PiPiper.driver).to receive(:i2c_transfer_bytes).with([1, 2, 3, 4])
        PiPiper::I2C.begin do
          write to: 4, data: [1, 2, 3, 4]
        end
      end
    end
  end
end
