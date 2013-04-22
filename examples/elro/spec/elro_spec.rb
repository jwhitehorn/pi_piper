require_relative '../elro_switch'

describe ElroSwitch do

  it "generates correct sequence for key" do
    ElroSwitch.sequence_for_key([0,0,1,0,1]).should == 
      [142, 142, 136, 142, 136]
  end

  it "not allows wrong key length" do
    expect {ElroSwitch.new(1, [0,0,1,0,1,0], nil)}.to raise_error ArgumentError
  end

  it "generates correct sequence for device" do
    ElroSwitch.sequence_for_device(7).should == 
      [136, 136, 136, 142, 142]
  end

  it "converts numbers to bits" do
    ElroSwitch.convert_to_bits(7, 8).should == [false, false, false, false, false, true, true, true]
  end

  it "converts sequence to bit pulses" do
    ElroSwitch.pulses_from_sequence([136, 142]).should == 
      [
        true, false, false, false, true, false, false, false,
        true, false, false, false, true, true,  true,  false
      ]
  end

  it "sends pulses" do
    pin = double("pi_piper_pin")
    pin.stub(:off)
    pin.should_receive(:update_value).exactly(40).times

    ElroSwitch.send_pulses(pin, [true, false, false, true])
  end

end
