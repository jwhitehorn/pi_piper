require 'spec_helper'
include PiPiper

describe 'Pin' do

  before(:context) do
    PiPiper.driver = PiPiper::Driver
  end

  it 'should set pin for input' do    
    expect(PiPiper.driver).to receive(:pin_direction).with(4, :in)
    Pin.new pin: 4, direction: :in
  end

  it 'should set pin for output' do
    expect(PiPiper.driver).to receive(:pin_direction).with(4, :out)
    Pin.new pin: 4, direction: :out
  end

  it 'should read start value on construction' do
    expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(0)
    Pin.new pin: 4, direction: :in
  end

  it 'should detect on?' do
    expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(1)
    pin = Pin.new pin: 4, direction: :in
    expect(pin.on?).to be(true)
  end

  it 'should detect off?' do
    expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(0)
    pin = Pin.new pin: 4, direction: :in
    expect(pin.off?).to be(true)
  end

  it 'should invert true' do
    expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(1)
    pin = Pin.new pin: 4, direction: :in, invert: true
    expect(pin.on?).to be(false)
  end

  it 'should invert true' do
    expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(0)
    pin = Pin.new pin: 4, direction: :in, invert: true
    expect(pin.off?).to be(false)
  end

  it 'should write high' do
    expect(PiPiper.driver).to receive(:pin_write).with(4, 1)
    pin = Pin.new pin: 4, direction: :out
    pin.on
  end

  it 'should write low' do
    expect(PiPiper.driver).to receive(:pin_write).with(4, 0)
    pin = Pin.new pin: 4, direction: :out
    pin.off
  end

  it 'should not write high on direction in' do
    expect(PiPiper.driver).not_to receive(:pin_write)
    pin = Pin.new pin: 4, direction: :in
    pin.on
  end

  it 'should not write low on direction in' do
    expect(PiPiper.driver).not_to receive(:pin_write)
    pin = Pin.new pin: 4, direction: :in
    pin.off
  end

  it 'should detect high to low change' do
    value = 1
    # begins low, then high, low, high, low...
    allow(PiPiper.driver).to receive(:pin_read) { value ^= 1 }

    pin = Pin.new pin: 4, direction: :in
    expect(pin.off?).to be(true)
    pin.read
    expect(pin.off?).to be(false)
    expect(pin.changed?).to be(true)
  end

  it 'should wait for change' do
    expect(PiPiper.driver).to receive(:pin_wait_for).with(4, :rising)
    pin = Pin.new pin: 4, direction: :out, trigger: :rising
    pin.wait_for_change
  end

  it 'should accept pulls when direction is :in' do
    expect(PiPiper.driver).to receive(:pin_set_pud).with(17, :up)
    expect(PiPiper.driver).to receive(:pin_set_pud).with(18, :down)
    expect(PiPiper.driver).to receive(:pin_set_pud).with(19, :off)
    expect(PiPiper.driver).to receive(:pin_set_pud).with(20, :float)

    Pin.new(pin: 17, direction: :in, pull: :up)
    Pin.new(pin: 18, direction: :in, pull: :down)
    Pin.new(pin: 19, direction: :in, pull: :off)
    Pin.new(pin: 20, direction: :in, pull: :float)
  end

  it 'should not accept pulls when direction is :out' do
    expect{ Pin.new(pin: 17, direction: :out, pull: :up) }.to raise_error PinError
    expect{ Pin.new(pin: 17, direction: :out, pull: :down) }.to raise_error PinError
    expect{ Pin.new(pin: 17, direction: :out, pull: :off) }.not_to raise_error
  end
end
