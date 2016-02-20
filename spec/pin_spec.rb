require 'spec_helper'
include PiPiper

describe 'Pin' do

  before(:example) do |example|
    Platform.driver = StubDriver.new
  end

  context 'Basic Behaviour' do
    it 'should export pin for input' do    
      expect(Platform.driver).to receive(:pin_input).with(4)
      Pin.new pin: 4, direction: :in
    end

    it 'should export pin for output' do
      expect(Platform.driver).to receive(:pin_output).with(4)
      Pin.new pin: 4, direction: :out
    end

    it 'should read start value on construction' do
      expect(Platform.driver).to receive(:pin_read).with(4).and_return(0)
      Pin.new pin: 4, direction: :in
    end

    it 'should detect on?' do
      expect(Platform.driver).to receive(:pin_read).with(4).and_return(1)
      pin = Pin.new pin: 4, direction: :in
      expect(pin.on?).to be(true)
    end

    it 'should detect off?' do
      expect(Platform.driver).to receive(:pin_read).with(4).and_return(0)
      pin = Pin.new pin: 4, direction: :in
      expect(pin.off?).to be(true)
    end

    it 'should invert true' do
      expect(Platform.driver).to receive(:pin_read).with(4).and_return(1)
      pin = Pin.new pin: 4, direction: :in, invert: true
      expect(pin.on?).to be(false)
    end

    it 'should invert true' do
      expect(Platform.driver).to receive(:pin_read).with(4).and_return(0)
      pin = Pin.new pin: 4, direction: :in, invert: true
      expect(pin.off?).to be(false)
    end

    it 'should write high' do
      expect(Platform.driver).to receive(:pin_set).with(4, 1)
      pin = Pin.new pin: 4, direction: :out
      pin.on
    end

    it 'should write low' do
      expect(Platform.driver).to receive(:pin_set).with(4, 0)
      pin = Pin.new pin: 4, direction: :out
      pin.off
    end

    it 'should not write high on direction in' do
      expect(Platform.driver).not_to receive(:pin_set)
      pin = Pin.new pin: 4, direction: :in
      pin.on
    end

    it 'should not write low on direction in' do
      expect(Platform.driver).not_to receive(:pin_set)
      pin = Pin.new pin: 4, direction: :in
      pin.off
    end

    it 'should detect high to low change' do
      value = 1
      # begins low, then high, low, high, low...
      allow(Platform.driver).to receive(:pin_read) { value ^= 1 }

      pin = Pin.new pin: 4, direction: :in
      expect(pin.off?).to be(true)
      pin.read
      expect(pin.off?).to be(false)
      expect(pin.changed?).to be(true)
    end

    it 'should wait for change' do
      pending 'how could we test event triggered code ?!'
      fail
    end
  end

  describe 'Pull up/down/float' do
    let!(:pin_up) do
      Pin.new(pin: 17, direction: :in, pull: :up)
    end
    let!(:pin_down) do
      Pin.new(pin: 17, direction: :in, pull: :down)
    end
    let!(:pin_off) do
      Pin.new(pin: 17, direction: :in, pull: :off)
    end
    let!(:pin_float) do
      Pin.new(pin: 17, direction: :in, pull: :float)
    end

    it 'should raise an error for invalid :pull values' do
      expect { Pin.new(pin: 17, direction: :in, pull: :wth) }.to raise_error PinError
    end

    it 'should restrict allowed :pull values' do
      expect(pin_up.pull?).to eq(:up)
      expect(pin_down.pull?).to eq(:down)
      expect(pin_off.pull?).to eq(:off)
      expect(pin_float.pull?).to eq(:off)
    end

    it 'should not accept pulls when direction is :out' do
      expect{ Pin.new(pin: 17, direction: :out, pull: :up) }.to raise_error PinError
      expect{ Pin.new(pin: 17, direction: :out, pull: :down) }.to raise_error PinError
      expect{ Pin.new(pin: 17, direction: :out, pull: :off) }.not_to raise_error
    end

    it 'should not allow pull! when direction is :out' do
      p_out = Pin.new(pin: 17, direction: :out)
      expect{ p_out.pull!(:up) }.to raise_error PinError
      expect{ p_out.pull!(:down) }.to raise_error PinError
      expect{ p_out.pull!(:off) }.not_to raise_error
    end

    it 'should allow subsequent pull resistor changes when direction is :in' do
      expect(Platform.driver).to receive(:pin_set_pud).with(17, PinValues::GPIO_PUD_UP)
      expect(Platform.driver).to receive(:pin_set_pud).with(17, PinValues::GPIO_PUD_DOWN)
      expect(Platform.driver).to receive(:pin_set_pud).with(17, PinValues::GPIO_PUD_OFF)
      pin_off.pull!(:up)
      pin_off.pull!(:down)
      pin_off.pull!(:off)
    end
  end
end
