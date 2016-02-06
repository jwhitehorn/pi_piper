require 'spec_helper'
include PiPiper

describe 'Pin' do
  it 'should export pin for input' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).to receive(:pin_input).with(4)
    end
    Pin.new pin: 4, direction: :in
  end

  it 'should export pin for output' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).to receive(:pin_output).with(4)
    end

    Pin.new pin: 4, direction: :out
  end

  it 'should read start value on construction' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).to receive(:pin_read).with(4).and_return(0)
    end

    Pin.new pin: 4, direction: :in
  end

  it 'should detect on?' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).to receive(:pin_read).with(4).and_return(1)
    end

    pin = Pin.new pin: 4, direction: :in
    expect(pin.on?).to be(true)
  end

  it 'should detect off?' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).to receive(:pin_read).with(4).and_return(0)
    end

    pin = Pin.new pin: 4, direction: :in
    expect(pin.off?).to be(true)
  end

  it 'should invert true' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).to receive(:pin_read).with(4).and_return(1)
    end

    pin = Pin.new pin: 4, direction: :in, invert: true
    expect(pin.on?).to be(false)
  end

  it 'should invert true' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).to receive(:pin_read).with(4).and_return(0)
    end

    pin = Pin.new pin: 4, direction: :in, invert: true
    expect(pin.off?).to be(false)
  end

  it 'should write high' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).to receive(:pin_set).with(4, 1)
    end

    pin = Pin.new pin: 4, direction: :out
    pin.on
  end

  it 'should write low' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).to receive(:pin_set).with(4, 0)
    end

    pin = Pin.new pin: 4, direction: :out
    pin.off
  end

  it 'should not write high on direction in' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).not_to receive(:pin_set)
    end

    pin = Pin.new pin: 4, direction: :in
    pin.on
  end

  it 'should not write low on direction in' do
    Platform.driver = StubDriver.new.tap do |d|
      expect(d).not_to receive(:pin_set)
    end

    pin = Pin.new pin: 4, direction: :in
    pin.off
  end

  it 'should detect high to low change' do
    Platform.driver = StubDriver.new.tap do |d|
      value = 1
      # begins low, then high, low, high, low...
      allow(d).to receive(:pin_read) { value ^= 1 }
    end

    pin = Pin.new pin: 4, direction: :in
    expect(pin.off?).to be(true)
    pin.read
    expect(pin.off?).to be(false)
    expect(pin.changed?).to be(true)
  end

  xit 'should wait for change' do
    pending
  end

  context 'given a pin is released' do
    it 'should actually release it' do
      Platform.driver = StubDriver.new.tap do |driver|
        expect(driver).to receive(:release_pin).with(4)
      end
   
      pin = Pin.new(pin: 4, direction: :in)
      pin.release
      expect(pin.released?).to be(true)
    end

    it 'should not mark unreleased pins as released' do
      pin = Pin.new(pin: 4, direction: :in)
      expect(pin.released?).to be(false)
    end

    it 'should not continue to use the pin' do
      Platform.driver = StubDriver.new.tap do |driver|
        expect(driver).to receive(:release_pin).with(4)
      end

      pin = Pin.new(pin: 4, direction: :in)
      pin.release

      expect { pin.read }.to raise_error(PinError, 'Pin 4 already released')
      expect { pin.on }.to raise_error(PinError, 'Pin 4 already released')
      expect { pin.off }.to raise_error(PinError, 'Pin 4 already released')
      expect { pin.pull!(:up) }.to(
        raise_error(PinError, 'Pin 4 already released'))
    end
  end
end
