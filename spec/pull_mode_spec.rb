require_relative 'spec_helper'

describe 'Pi_Piper' do
  Platform.driver = StubDriver.new
  describe "when a pin is created" do

    it "should restrict allowed :pull values" do
      proc { PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :wth) }.should raise_exception(RuntimeError)

      PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :up).pull?.should eql(:up)
      PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :down).pull?.should eql(:down)
      PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :off).pull?.should eql(:off)
      PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :float).pull?.should eql(:off)
    end

    xit "should not accept pulls when direction is :out" do
      proc { raise }.should_not raise_exception(RuntimeError)
    end

    xit "should not allow pull! when direction is :out" do
      proc { raise }.should_not raise_exception(RuntimeError)
    end

    xit "should not allow subsequent pull resistor changes when direction is :out" do
      true.must_equal false
    end

    xit "should allow subsequent pull resistor changes when direction is :in" do
      true.must_equal false
    end
  end

  describe "when pull mode is set to up" do
    before :each do
      @pin = PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :up)
    end

    it "must respond HIGH when floating pins are checked" do
      @pin.on?.should be_true
    end
  end

  describe "when pull mode is set to down" do
    before :each do
      @pin = PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :down)
    end

    it "must respond LOW when flaoting pins are checked" do
      @pin.off?.should be_true
    end
  end
end

