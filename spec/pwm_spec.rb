require 'spec_helper'
include PiPiper

describe 'Pwm' do
  before(:context) do
    PiPiper.driver = PiPiper::Driver
  end
  
  describe '#new' do
    it 'should get the options right' do
      default_pwm =  PiPiper::Pwm.new(pin: 18)
      expect(default_pwm.options).to eq({ pin: 18, mode: :balanced, clock: 19200000.0, range: 1024})
      expect(default_pwm.value).to eq(0)

      custom_pwm =  PiPiper::Pwm.new(pin: 18, mode: :markspace, clock: 1.megahertz, range: 10000, value: 1)
      expect(custom_pwm.options).to eq({ pin: 18, mode: :markspace, clock: 1000000.0, range: 10000})
      expect(custom_pwm.value).to eq(1)
    end

    it 'should set the options' do
      expect(PiPiper.driver).to receive(:pwn_set_pin).with(20)
      expect(PiPiper.driver).to receive(:pwm_set_clock).with(9)
      expect(PiPiper.driver).to receive(:pwm_set_range).with(20, 2)
      expect(PiPiper.driver).to receive(:pwm_set_mode).with(20, :markspace)

      PiPiper::Pwm.new pin: 20, range: 2, mode: :markspace, clock: 2.megahertz
    end

  end

  let!(:pwm) { PiPiper::Pwm.new pin: 18 }
  
  describe 'start/stop & status' do
    it '#on' do
      expect(PiPiper.driver).to receive(:pwm_set_mode).twice.with(18, :balanced, 1)
      pwm.on
      pwm.start
    end

    it '#off' do
      expect(PiPiper.driver).to receive(:pwm_set_mode).twice.with(18, :balanced, 0)
      pwm.off
      pwm.stop
    end
    
    it '#on?' do
      pwm.on
      expect(pwm.on?).to be true
      pwm.off
      expect(pwm.on?).to be false
    end

    it '#off?' do
      pwm.on
      expect(pwm.off?).to be false
      pwm.off
      expect(pwm.off?).to be true
    end
  end

  describe '#value=' do
    it 'should set value between 0 and 1' do
      expect(PiPiper.driver).to receive(:pwm_set_data).with(18, (0.4*1024).to_i)
      pwm.value = 0.4
      expect(pwm.value).to eq 0.4
    end

    it 'should set caped value outside 0 and 1' do
      pwm.value = 2
      expect(pwm.value).to eq 1
      pwm.value = -2
      expect(pwm.value).to eq 0
    end
  end
end
