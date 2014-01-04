require 'spec_helper'
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

    Pin.new :pin => 4, :direction => :in
  end
  
  it "should detect on?" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_read).with(4).and_return(1)
    end

    pin = Pin.new :pin => 4, :direction => :in
    pin.on?.should == true
  end
  
  it "should detect off?" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_read).with(4).and_return(0)
    end

    pin = Pin.new :pin => 4, :direction => :in
    pin.off?.should == true
  end
  
  it "should invert true" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_read).with(4).and_return(1)
    end

    pin = Pin.new :pin => 4, :direction => :in, :invert => true
    pin.on?.should == false    
  end
  
  it "should invert true" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_read).with(4).and_return(0)
    end

    pin = Pin.new :pin => 4, :direction => :in, :invert => true
    pin.off?.should == false    
  end  
  
  it "should write high" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_set).with(4, 1)
    end

    pin = Pin.new :pin => 4, :direction => :out
    pin.on
  end
  
  it "should write low" do
    Platform.driver = StubDriver.new.tap do |d|
      d.should_receive(:pin_set).with(4, 0)
    end

    pin = Pin.new :pin => 4, :direction => :out
    pin.off
  end
  
  it "shouldn't write high on direction in" do
    Platform.driver = StubDriver.new.tap do |d|
      d.stub(:pin_set) { fail }
    end

    pin = Pin.new :pin => 4, :direction => :in
    pin.on    
  end
  
  it "shouldn't write low on direction in" do
    Platform.driver = StubDriver.new.tap do |d|
      d.stub(:pin_set) { fail }
    end

    pin = Pin.new :pin => 4, :direction => :in
    pin.off    
  end
  
  it "should detect high to low change" do
    Platform.driver = StubDriver.new.tap do |d|
      value = 1
      d.stub(:pin_read) { value ^= 1 } #begins low, then high, low, high, low...
    end

    pin = Pin.new :pin => 4, :direction => :in
    pin.off?.should == true
    pin.read
    pin.off?.should == false
    pin.changed?.should == true
  end
  
  #it "should wait for change" do
  #  fail
  #end

end
