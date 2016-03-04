require 'spec_helper'

describe PiPiper::Pin do

  before(:context) do
    PiPiper.driver = PiPiper::Driver
  end

  context 'when instantiate' do
    it 'should set pin for input' do    
      expect(PiPiper.driver).to receive(:pin_direction).with(4, :in)
      PiPiper::Pin.new pin: 4, direction: :in
    end

    it 'should set pin for output' do
      expect(PiPiper.driver).to receive(:pin_direction).with(4, :out)
      PiPiper::Pin.new pin: 4, direction: :out
    end

    it 'should read start value on construction' do
      expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(0)
      PiPiper::Pin.new pin: 4, direction: :in
    end

    it 'should accept pulls when direction is :in' do
      expect(PiPiper.driver).to receive(:pin_set_pud).with(17, :up)
      expect(PiPiper.driver).to receive(:pin_set_pud).with(18, :down)
      expect(PiPiper.driver).to receive(:pin_set_pud).with(19, :off)
      expect(PiPiper.driver).to receive(:pin_set_pud).with(20, :float)

      PiPiper::Pin.new(pin: 17, direction: :in, pull: :up)
      PiPiper::Pin.new(pin: 18, direction: :in, pull: :down)
      PiPiper::Pin.new(pin: 19, direction: :in, pull: :off)
      PiPiper::Pin.new(pin: 20, direction: :in, pull: :float)
    end

    it 'should not accept pulls when direction is :out' do
      expect{ PiPiper::Pin.new(pin: 17, direction: :out, pull: :up) }.to raise_error ArgumentError
      expect{ PiPiper::Pin.new(pin: 17, direction: :out, pull: :down) }.to raise_error ArgumentError
      expect{ PiPiper::Pin.new(pin: 17, direction: :out, pull: :off) }.not_to raise_error
    end

    it 'should accept trigger' do
      expect(PiPiper.driver).to receive(:pin_set_trigger).with(17, :any_trigger)
      expect(PiPiper.driver).to receive(:pin_set_trigger).with(18, :none)
      PiPiper::Pin.new(pin: 17, direction: :in, trigger: :any_trigger)
      PiPiper::Pin.new(pin: 18, direction: :in)
    end
  end


  context 'when direction is in' do
    subject { PiPiper::Pin.new pin: 4, direction: :in }

    it 'should detect on?' do
      expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(1)
      expect(subject.on?).to be(true)
    end

    it 'should detect off?' do
      expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(0)
      expect(subject.off?).to be(true)
    end

    it 'should not write high on direction in' do
      expect(PiPiper.driver).not_to receive(:pin_write)
      subject.on
    end

    it 'should not write low on direction in' do
      expect(PiPiper.driver).not_to receive(:pin_write)
      subject.off
    end

    it 'should detect high to low change' do
      value = 1
      allow(PiPiper.driver).to receive(:pin_read) { value ^= 1 } # begins low, then high, low, high, low...

      expect(subject.off?).to be(true)
      subject.read
      expect(subject.off?).to be(false)
      expect(subject.changed?).to be(true)
    end

    context 'when invert is true' do
      subject { PiPiper::Pin.new pin: 4, direction: :in, invert: true }
      
      it 'should invert true' do
        expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(1)
        expect(subject.on?).to be(false)
      end

      it 'should invert true' do
        expect(PiPiper.driver).to receive(:pin_read).with(4).and_return(0)
        expect(subject.off?).to be(false)
      end
    end
  end

  context 'when direction is out' do
    subject { PiPiper::Pin.new pin: 4, direction: :out }

    it 'should write high' do
      expect(PiPiper.driver).to receive(:pin_write).with(4, 1)
      subject.on
    end

    it 'should write low' do
      expect(PiPiper.driver).to receive(:pin_write).with(4, 0)
      subject.off
    end
  end

  it 'should wait for change' do
    expect(PiPiper.driver).to receive(:pin_wait_for).with(4)
    pin = PiPiper::Pin.new pin: 4, direction: :in, trigger: :rising
    pin.wait_for_change
  end
end
