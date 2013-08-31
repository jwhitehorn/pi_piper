require '../pi_piper/lib/pi_piper.rb'
require 'stub_driver.rb'
include PiPiper

describe 'Pin' do

  it "should export pin for input" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_input).with(4)
    end

    Pin.new :pin => 4, :direction => :in
  end
  
  it "should export pin for output" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_output).with(4)
    end

    Pin.new :pin => 4, :direction => :out
  end
  
  it "should read start value on construction" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_read).with(4).and_return(0)
    end

    Pin.new :pin => 4, :direction => :out
  end
  
  it "should detect on?" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_read).with(4).and_return(1)
    end

    pin = Pin.new :pin => 4, :direction => :out
    pin.on?.should == true
  end
  
  it "should detect off?" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_read).with(4).and_return(0)
    end

    pin = Pin.new :pin => 4, :direction => :out
    pin.off?.should == true
  end
  
  it "should invert true" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_read).with(4).and_return(1)
    end

    pin = Pin.new :pin => 4, :direction => :out, :invert => true
    pin.on?.should == false    
  end
  
  it "should invert true" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_read).with(4).and_return(0)
    end

    pin = Pin.new :pin => 4, :direction => :out, :invert => true
    pin.off?.should == false    
  end  

end
