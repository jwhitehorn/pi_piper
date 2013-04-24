require 'spec_helper'

describe ElroSwitch do

  it "not allows wrong key length" do
    expect {ElroSwitch.new(1, [0,0,1,0,1,0], nil)}.to raise_error ArgumentError
  end

  it "sends pulses on switch" do
    pin = double("pi_piper_pin")
    pin.stub(:off)
    pin.should_receive(:update_value).exactly(16 * 8 * 10).times

    elro = ElroSwitch.new(1, [0,0,1,0,1], pin)
    elro.switch(true)
  end

end
