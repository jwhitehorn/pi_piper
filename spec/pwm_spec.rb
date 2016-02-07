require 'spec_helper'
include PiPiper

describe 'Pwm' do
  around(:example) do |example|
    Platform.driver = StubDriver.new.tap do |d|
        example.run
    end
  end
  
  describe 'new' do
    it 'should get the options right' do
      default_pwm =  PiPiper::Pwm.new pin: 18
      expect(default_pwm.options).to eq({:mode=>:balanced, :clock=>19200000.0, :range=>1024})
      expect(default_pwm.pin).to eq(18)
      expect(default_pwm.value).to eq(0)

      custom_pwm =  PiPiper::Pwm.new pin: 18, mode: :markspace, clock: 1.megahertz, range: 10000, value: 1
      expect(custom_pwm.options).to eq({mode: :markspace, clock: 1000000.0, range: 10000})
      expect(custom_pwm.pin).to eq(18)
      expect(custom_pwm.value).to eq(1)
    end

    it 'should reject wrong options value' do
      expect { PiPiper::Pwm.new pin: 0 }.to raise_error(ArgumentError, ':pin should be one of  [12, 13, 18, 19, 40, 41, 45, 52, 53] not 0')
      expect { PiPiper::Pwm.new pin: 18 }.not_to raise_error
      expect { PiPiper::Pwm.new pin: 18, mode: :balanced }.not_to raise_error
      expect { PiPiper::Pwm.new pin: 18, mode: :markspace}.not_to raise_error
      expect { PiPiper::Pwm.new pin: 18, mode: :another_mode }.to raise_error(ArgumentError, ':mode should be one of [:balanced, :markspace], not another_mode')
    end

    it 'should set the options' do
      expect(Platform.driver).to receive(:gpio_select_function).with(18, 0b010)
      expect(Platform.driver).to receive(:pwm_clock).with(9)
      expect(Platform.driver).to receive(:pwm_range).with(0, 2)
      expect(Platform.driver).to receive(:pwm_mode).with(0, 1, 1)

      pwm =  PiPiper::Pwm.new pin: 18, range: 2, mode: :markspace, clock: 2.megahertz
    end

  end

  let!(:pwm) { PiPiper::Pwm.new pin: 18 }

  it 'on' do
    expect(Platform.driver).to receive(:pwm_mode).twice.with(0, 0, 1)
    pwm.on
    pwm.start
  end

  it 'off' do
    expect(Platform.driver).to receive(:pwm_mode).twice.with(0, 0, 0)
    pwm.off
    pwm.stop
  end
  
  it 'on? / off?' do
    pwm.on
    expect(pwm.on?).to be true
    expect(pwm.off?).to be false
    pwm.off
    expect(pwm.on?).to be false
    expect(pwm.off?).to be true
  end

  it 'should set value between 0 and 1' do
    expect(Platform.driver).to receive(:pwm_data).with(0, (0.4*1024).to_i)
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
