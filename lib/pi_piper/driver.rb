module PiPiper
  class Driver
    
    VERSION = '0.1.0'

    def initialize
    end

    def close
    end

# Pin
    def pin_direction(pin, direction)
    end

    def pin_read(pin)
    end

    def pin_write(pin, value)
    end

    def pin_set_pud(pin, value)
    end

    def pin_set_trigger(pin, value)
    end

    def pin_wait_for(pin, trigger)
    end

# PWM
    def pwm_set_pin(pin)
    end

    def pwm_set_clock(clock_value)
    end

    def pwm_set_mode(pin, mode, start = 1)
    end

    def pwm_set_range(pin, range)
    end

    def pwm_set_data(pin, data)
    end

# SPI
    def spi_begin
    end

    def spi_end
    end

    def spi_set_data_mode(mode)
    end

    def spidev_out(array)
    end

    def spi_clock(clock_divider)
    end

    def spi_bit_order(order)
    end

    def spi_chip_select(cs)
    end

    def spi_chip_select_polarity(cs, active)
    end

    def spi_transfer(byte)
    end

    def spi_transfer_bytes(data)
    end

# I2C
    def i2c_begin
    end

    def i2c_end
    end

    def i2c_allowed_clocks
    end

    def i2c_set_clock_divider(divider)
    end

    def i2c_set_clock(clock)
    end

    def i2c_set_address(address)
    end

    def i2c_transfer_bytes(data)
    end

    def i2c_read_bytes(bytes)
    end

    def i2c_write(data_out, bytes)
    end

    def i2c_read(data_in, bytes)
    end
  end  
end