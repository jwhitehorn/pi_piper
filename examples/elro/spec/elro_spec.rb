require_relative '../elro_switch'

describe ElroSwitch do

  it "should generate the correct sequence for key" do
    elro = ElroSwitch.new(1, key=[0,0,1,0,1], nil)

    elro.instance_eval{ sequence_for_key }.should == 
      [ElroSwitch::DIP_OFF,ElroSwitch::DIP_OFF,ElroSwitch::DIP_ON,ElroSwitch::DIP_OFF,ElroSwitch::DIP_ON]
  end

end
