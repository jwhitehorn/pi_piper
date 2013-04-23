require 'elro_switch'

describe ElroSwitch do

  it "not allows wrong key length" do
    expect {ElroSwitch.new(1, [0,0,1,0,1,0], nil)}.to raise_error ArgumentError
  end

end
