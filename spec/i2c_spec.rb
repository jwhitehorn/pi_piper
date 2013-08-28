require '../pi_piper/lib/pi_piper.rb'
require 'stub_driver.rb'
include PiPiper

describe 'pi_piper' do
  describe "when in i2c block" do

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

  end
end
