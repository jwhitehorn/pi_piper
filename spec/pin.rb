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

end
