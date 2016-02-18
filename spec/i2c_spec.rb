require_relative 'spec_helper'

describe 'I2C' do

  before(:example) do |example|
    Platform.driver = StubDriver.new
  end
  
  describe 'clock setting' do
    it 'should check driver settings' do
      expect(Platform.driver).to receive(:i2c_allowed_clocks).and_return([100.kilohertz])
      I2C.clock = 100.kilohertz
    end

    it 'should accept 100 kHz' do
      expect(Platform.driver).to receive(:i2c_allowed_clocks).and_return([100.kilohertz])
      expect(Platform.driver).to receive(:i2c_set_clock).with(100.kilohertz)
      I2C.clock = 100.kilohertz
    end

    it 'should not accept 200 kHz' do
      expect(Platform.driver).to receive(:i2c_allowed_clocks).and_return([100.kilohertz])
      expect { I2C.clock = 200.kilohertz }.to raise_error(RuntimeError)
    end
  end

  describe 'when in block' do
    it 'should call i2c_begin' do
      expect(Platform.driver).to receive(:i2c_begin)
      I2C.begin {}
    end

    it 'should call i2c_end' do
      expect(Platform.driver).to receive(:i2c_end)
      I2C.begin {}
    end

    it 'should call i2c_end even after raise' do
      expect(Platform.driver).to receive(:i2c_end)
      begin
        I2C.begin { raise 'OMG' }
      rescue
      end
    end

    describe 'write operation' do
      it 'should set address' do
        expect(Platform.driver).to receive(:i2c_set_address).with(4)
        I2C.begin do
          write to: 4, data: [1, 2, 3, 4]
        end
      end

      it 'should pass data to driver' do
        expect(Platform.driver).to receive(:i2c_transfer_bytes).with([1, 2, 3, 4])
        I2C.begin do
          write to: 4, data: [1, 2, 3, 4]
        end
      end
    end
  end
end
