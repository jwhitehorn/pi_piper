require 'spec_helper'

describe ElroUtil do

  it "generates correct sequence for key" do
    ElroUtil.sequence_for_key([0,0,1,0,1]).should == 
      [142, 142, 136, 142, 136]
  end

  it "generates correct sequence for device" do
    ElroUtil.sequence_for_device(7).should == 
      [136, 136, 136, 142, 142]
  end

  it "generates correct sequence for device as array" do
    ElroUtil.sequence_for_device([1,1,1,0,0]).should == 
      [136, 136, 136, 142, 142]
  end

  it "generates correct sequence for on/off" do
    ElroUtil.sequence_for_onoff(true).should == 
      [136, 142]
    ElroUtil.sequence_for_onoff(false).should == 
      [142, 136]
  end

  it "generates correct sequence for static part" do
    ElroUtil.sequence_for_static_part.should == 
      [128, 0, 0, 0]
  end

  it "converts numbers to bits" do
    ElroUtil.convert_to_bits(7, 8).should == [false, false, false, false, false, true, true, true]
  end

  it "converts sequence to bit pulses" do
    ElroUtil.pulses_from_sequence([136, 142]).should == 
      [
        true, false, false, false, true, false, false, false,
        true, false, false, false, true, true,  true,  false
      ]
  end

  it "sends pulses" do
    pin = double("pi_piper_pin")
    pin.stub(:off)
    pin.should_receive(:update_value).exactly(40).times

    ElroUtil.send_pulses(pin, [true, false, false, true])
  end

end
