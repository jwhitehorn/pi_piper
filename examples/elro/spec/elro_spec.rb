require 'spec_helper'

describe ElroSwitch do

  it "does not allow wrong key length" do
    expect {ElroSwitch.new(1, [0,0,1,0,1,0], nil)}.to raise_error ArgumentError
  end

  it "does expect a Numeric or a List as device" do
    expect {ElroSwitch.new([0,0,0,0,0], [0,1,0,1,0], nil)}.not_to raise_error ArgumentError
    expect {ElroSwitch.new(15, [0,1,0,1,0], nil)}.not_to raise_error ArgumentError
    expect {ElroSwitch.new("x", [0,1,0,1,0], nil)}.to raise_error ArgumentError
  end

  it "does expect a numeric device to be between 0 and 31" do
    expect {ElroSwitch.new(-1, [0,1,0,1,0], nil)}.to raise_error ArgumentError
    expect {ElroSwitch.new( 0, [0,1,0,1,0], nil)}.not_to raise_error ArgumentError
    expect {ElroSwitch.new(31, [0,1,0,1,0], nil)}.not_to raise_error ArgumentError
    expect {ElroSwitch.new(32, [0,1,0,1,0], nil)}.to raise_error ArgumentError
  end

  it "does not allow wrong device length" do
    expect {ElroSwitch.new([0,0,0,0], [0,1,0,1,0], nil)}.to raise_error ArgumentError
  end

  it "sends pulses on switch" do
    pin = double("pi_piper_pin")
    pin.should_receive(:update_value).exactly(16 * 8 * 10 + 1).times

    elro = ElroSwitch.new(1, [0,0,1,0,1], pin)
    elro.switch(true)
  end

end
