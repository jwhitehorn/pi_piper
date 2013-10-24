require 'spec_helper'

describe StubDriver do

  let(:stub_driver){StubDriver.new()}

  before do
    @logger = double()
    @logger_driver = StubDriver.new(:logger => @logger)
  end

  describe '#pin_input' do

    it 'should set pin as input' do
      stub_driver.pin_input(10)
      stub_driver.pin_direction(10).should == :in
    end

    it 'should log that pin is set' do
      @logger.expects(:debug).with('Pin #10 -> Input')
      @logger_driver.pin_input(10)
    end

  end

  describe '#pin_output' do

    it 'should set pin as output' do
      stub_driver.pin_output(10)
      stub_driver.pin_direction(10).should == :out
    end

    it 'should log that pin is set' do
      @logger.expects(:debug).with('Pin #10 -> Output')
      @logger_driver.pin_output(10)
    end

  end

  describe '#pin_set' do

    it 'should set pin value' do
      stub_driver.pin_set(22, 42)
      stub_driver.pin_read(22).should == 42
    end

    it 'should log the new pin value' do
      @logger.expects(:debug).with('Pin #21 -> 22')
      @logger_driver.pin_set(21, 22)
    end

  end

  describe '#pin_set_pud' do
    it 'should set pin value' do
      stub_driver.pin_set_pud(12, Pin::GPIO_PUD_UP)
      stub_driver.pin_read(12).should == Pin::GPIO_HIGH
    end

    it 'should not overwrite set value' do
      stub_driver.pin_set(12,0)
      stub_driver.pin_set_pud(12, Pin::GPIO_PUD_DOWN)
      stub_driver.pin_read(12).should == Pin::GPIO_LOW
    end

    it 'should log the new pin value' do
      @logger.expects(:debug).with('PinPUD #21 -> 22')
      @logger_driver.pin_set_pud(21, 22)
    end
  end


  describe '#reset' do
    it 'should not reset unless asked' do
      StubDriver.new()
      StubDriver.pin_set(1,3)
      StubDriver.pin_read(1).should == 3
      StubDriver.reset
      StubDriver.pin_read(1).should be_nil
    end
  end

end
