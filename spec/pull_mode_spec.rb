require '../pi_piper/lib/pi_piper.rb'
require 'stub_driver.rb'
include PiPiper

describe 'Pi_Piper' do
  Platform.driver = StubDriver.new
  describe "when a pin is created" do
    it "should restrict allowed :pull values" do
      proc { PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :wth) }.must_raise RuntimeError
      PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :up).pull?.must_equal :up
      PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :down).pull?.must_equal :down
      PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :off).pull?.must_equal :off
      PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :float).pull?.must_equal :off
    end
    it "should not accept pulls when direction is :out" do
      proc { raise }.must_not_raise RuntimeError
    end
    it "should not allow pull! when direction is :out" do
      proc { raise }.must_not_raise RuntimeError
    end
    it "should not allow subsequent pull resistor changes when direction is :out" do
      true.must_equal false
    end
    it "should allow subsequent pull resistor changes when direction is :in" do
      true.must_equal false
    end
  end

  describe "when pull mode is set to up" do
    @pin = PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :up)
    it "must respond HIGH when floating pins are checked" do
      @pin.on?.must_be true
    end
  end

  describe "when pull mode is set to down" do
    @pin = PiPiper::Pin.new(:pin => 17, :direction => :in, :pull => :down)
    it "must respond LOW when flaoting pins are checked" do
      @pin.off?.must_be true
    end
  end
end

