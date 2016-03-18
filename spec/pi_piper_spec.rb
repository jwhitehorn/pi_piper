require 'spec_helper'

describe PiPiper do

  it 'should get the default driver' do
    expect(PiPiper.driver).to be_an_instance_of PiPiper::Driver
  end

  it 'should set a driver' do
    PiPiper.driver= PiPiper::Driver
    expect{ PiPiper.driver= Numeric }.to raise_error ArgumentError
    expect{ PiPiper.driver= nil }.to raise_error ArgumentError
    expect{ PiPiper.driver= PiPiper::Driver }.not_to raise_error
  end

  it 'should take in PiPiper::Driver subclasses' do
    loaded_driver = PiPiper.driver
    PiPiper::StubDriver = Class.new PiPiper::Driver
    
    expect(loaded_driver).to receive(:close)    
    expect{ PiPiper.driver= PiPiper::StubDriver }.not_to raise_error
  end

  xit 'should close the loaded driver at_exit'

  xit '#watch(options, &block)'
  xit '#after(options, &block)'
  xit '#poll_spi(options, &block)'
  xit '#when_spi(options, &block)'
  xit '#wait'

end
