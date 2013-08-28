require '../pi_piper/lib/pi_piper.rb'
require 'stub_driver.rb'
include PiPiper

describe 'I2C' do

  describe "clock setting" do
    it "should accept 100 kHz" do
      Platform.driver = StubDriver.new.tap do |d|                                            
        d.should_receive(:i2c_set_clock).with(100.kilohertz)                            
      end 

      I2C.clock = 100.kilohertz
    end
  end

  describe "when in block" do

    it "should call i2c_begin" do
      driver = StubDriver.new                                                                  
      expect(driver).to receive(:i2c_begin)  

      Platform.driver = driver
      I2C.begin do
      end
    end

    it "should call i2c_end" do                                     
      driver = StubDriver.new                                                                  
      expect(driver).to receive(:i2c_end)  

      Platform.driver = driver                                                                 
      I2C.begin do                                                                             
      end                                                                                      
    end 

    it "should call i2c_end even after raise" do
      driver = StubDriver.new 
      expect(driver).to receive(:i2c_end)

      Platform.driver = driver
      begin
        I2C.begin { raise "OMG" }
      rescue
      end
    end

    describe "write operation" do

      it "should set address" do
        Platform.driver = StubDriver.new.tap do |d|
          d.should_receive(:i2c_set_address).with(4)
        end
    
        I2C.begin do
          write :to => 4, :data => [1, 2, 3, 4]
        end
      end

      it "should pass data to driver" do
        Platform.driver = StubDriver.new.tap do |d|
          d.should_receive(:i2c_transfer_bytes).with([1, 2, 3, 4])
        end

        I2C.begin do
          write :to => 4, :data => [1, 2, 3, 4]
        end
      end

    end

  end
end
