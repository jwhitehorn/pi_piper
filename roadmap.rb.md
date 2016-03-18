    def self.pin_wait_for2(pin, trigger)
      pin_set_edge(pin, trigger)

      fd = File.open("/sys/class/gpio/gpio#{pin}/value", "r")
      fd.read
      IO.select(nil, nil, [fd], nil)
      true
    end





  # it 'should load a driver in the pool' do
  #   expect(PiPiper.load_driver(nil)).to eq nil
  #   expect(PiPiper.load_driver(Numeric)).to eq nil
  #   expect(loaded_driver = PiPiper.load_driver(PiPiper::Driver)).to be_an_instance_of PiPiper::Driver
  #   expect(PiPiper.load_driver(PiPiper::Driver)).to be loaded_driver
  # end

  # it 'should give acces to a driver from the pool' do
  #   PiPiper.load_driver(PiPiper::Driver)
  #   expect(PiPiper.get_driver(PiPiper::Driver)).to be_an_instance_of PiPiper::Driver
  #   expect(PiPiper.get_driver(Numeric)).to be_nil
  # end

  # it 'unlink_driver(klass)' do
  #   driver = PiPiper.load_driver(PiPiper::Driver)
  #   expect(driver).to receive(:close)
  #   expect(PiPiper.unlink_driver(PiPiper::Driver)).to be_an_instance_of PiPiper::Driver
  #   expect(PiPiper.get_driver(PiPiper::Driver)).to be_nil
  # end

  # it 'empty_pool' do
  #   Driver2 = Class.new PiPiper::Driver
  #   Driver3 = Class.new PiPiper::Driver
  #   PiPiper.load_driver(PiPiper::Driver)
  #   PiPiper.load_driver(Driver2)
  #   PiPiper.load_driver(Driver3)

  #   expect(PiPiper).to receive(:unlink_driver).with(PiPiper::Driver)
  #   expect(PiPiper).to receive(:unlink_driver).with(Driver2)
  #   expect(PiPiper).to receive(:unlink_driver).with(Driver3)
  #   PiPiper.empty_pool

  #   expect(PiPiper.get_driver(PiPiper::Driver)).to be_nil
  #   expect(PiPiper.get_driver(Driver2)).to be_nil
  #   expect(PiPiper.get_driver(Driver3)).to be_nil
  # end

  # xit 'default_driver=(klass)'
  # xit 'default_driver'















# Platform handle the loaded drivers and the way to load new drivers.
module PiPiper
  autoload StubDriver, 'blabla.rb'
  autoload SysFs, 'blabla.rb'
  autoload Bcm2835, 'blabla.rb'
  ...
  # @drivers_pool ||= {}

  # def load_driver(klass, *args)
  #   return nil if klass == nil

  #   if (PiPiper::Driver == klass.superclass || PiPiper::Driver == klass) && !@drivers_pool[klass].instance_of?(klass)
  #     @drivers_pool[klass] = klass.new(*args)
  #   end

  #   @drivers_pool[klass]
  # end

  # def get_driver(klass)
  #   @drivers_pool[klass]
  # end

  # def unlink_driver(klass)
  #   if get_driver(klass).instance_of? klass
  #     get_driver(klass).close
  #     @drivers_pool.delete klass
  #   end
  # end

  # def empty_pool
  #   @drivers_pool.keys.each {|d| unlink_driver(d) }
  # end

  # def default_driver=(klass)
  #   @default = load_driver(klass)
  # end

  # def default_driver
  #   @default
  # end

end

# StubDriver used to define the standart API, and to stub for testing
class StubDriver
  def initialize
    at_exit { close }
    # or define a finalizer : ObjectSpace.define_finalizer(object, proc)
  end

  def close
    # unexport pin
    # close librairy
    # ...
  end

  def each_public_method(*args)
    # kept empty for test matter
  end
end

# each driver could be in a separate gem (or just not required from start)
class SysFs < StubDriver

  def initialize
    @exported_pins = []
    super
  end

  def close
    @exported_pins.each {|p| unexport_pins(p) }
  end

  # Standart public methods conform to the 'API'
  # Methods prefix with the object they are used for
  def pin_set_...(gpio_number, value)
  end

  def pin_read(gpio_number)
  end

  def spi_poll
  end
  ...
  
  # private methods are not intended to be called from outside the driver.
private
  def export
  end

end

# Other Drivers could be bcm2835, gordon's wiringPi lib, platform specific lib for beaglebone, ordroid.... 


class Pin
  def initialize(options)
    # driver can be choosed at initialization time. it could be different for each object (in order to gain controle of specific behaviour)
    @options[:driver] = Platform.link__with_driver options[:driver]

    # we vallidate the options by setting them through the driver. Settings cannot be changed later.
    # the driver raise exceptions for invalid arguments
  end

  def close
    # Optional : close procedure/release if we cannot wait for the programm to end or the GC to collect
  end

...

private
# Optional : a way to access the driver directly for driver specific behaviour
  def method_missing(method, *args, &block)
    @options[:driver].send(method, @options[:pin], *args, &block)
  end
end

class Spi
# Same here
private
  def method_missing(method, *args, &block)
    @options[:driver].send(method, @options[:pin], *args, &block)
  end
end