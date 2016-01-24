require_relative 'spec_helper'

describe 'Pi_Piper' do
  before (:each) do
    Platform.driver = StubDriver.new
  end

  let(:pin_up) do
    PiPiper::Pin.new(pin: 17, direction: :in, pull: :up)
  end
  let(:pin_down) do
    PiPiper::Pin.new(pin: 17, direction: :in, pull: :down)
  end
  let(:pin_off) do
    PiPiper::Pin.new(pin: 17, direction: :in, pull: :off)
  end
  let(:pin_float) do
    PiPiper::Pin.new(pin: 17, direction: :in, pull: :float)
  end

  describe 'when a pin is created' do
    it 'should raise an error for invalid :pull values' do
      expect { PiPiper::Pin.new(pin: 17, direction: :in, pull: :wth) }.to(
        raise_error(RuntimeError))
    end

    it 'should restrict allowed :pull values' do
      expect(pin_up.pull?).to eq(:up)
      expect(pin_down.pull?).to eq(:down)
      expect(pin_off.pull?).to eq(:off)
      expect(pin_float.pull?).to eq(:off)
    end

    xit 'should not accept pulls when direction is :out' do
       expect{ raise }.not_to raise_error(RuntimeError)
    end

    xit 'should not allow pull! when direction is :out' do
      expect{ raise }.not_to raise_error(RuntimeError)
    end

    xit 'should not allow subsequent pull resistor changes when direction is :out' do
      expect(true).to eq(false)
    end

    xit 'should allow subsequent pull resistor changes when direction is :in' do
      expect(true).to eq(false)
    end
  end

  describe 'when pull mode is set to up' do
    before :each do
      @pin = pin_up
    end

    it 'must respond HIGH when floating pins are checked' do
      expect(@pin.on?).to be(true)
    end
  end

  describe 'when pull mode is set to down' do
    before :each do
      @pin = pin_down
    end

    it 'must respond LOW when floating pins are checked' do
      expect(@pin.off?).to be(true)
    end
  end
end
