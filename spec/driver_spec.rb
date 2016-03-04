require 'spec_helper'

describe PiPiper::Driver do
  it 'has a version number' do
    expect(PiPiper::Driver::VERSION).not_to be nil
  end

  subject { PiPiper::Driver.new }

  context 'init & close' do
    it '#new' do
      expect(PiPiper::Driver.new).to be_an_instance_of PiPiper::Driver
    end

    it '#close' do
      is_expected.to respond_to(:close).with(0).argument
    end
  end

  context 'API for Pin' do
    it '#pin_direction(pin, direction)' do
      is_expected.to respond_to(:pin_direction).with(2).arguments
    end

    it '#pin_write(pin, value)' do
      is_expected.to respond_to(:pin_write).with(2).arguments
    end

    it '#pin_read(pin)' do
      is_expected.to respond_to(:pin_read).with(1).argument
    end

    it '#pin_set_pud(pin, value)' do
      is_expected.to respond_to(:pin_set_pud).with(2).arguments
    end

    it '#pin_set_trigger(pin, trigger)' do
      is_expected.to respond_to(:pin_set_trigger).with(2).arguments
    end

    it '#pin_wait_for(pin)' do
      is_expected.to respond_to(:pin_wait_for).with(2).arguments
    end
  end

  context 'API for Pwm' do
    it '#pwn_set_pin(pin)' do
      is_expected.to respond_to(:pwm_set_pin).with(1).argument
    end

    it '#pwm_set_clock(clock_value)' do
      is_expected.to respond_to(:pwm_set_clock).with(1).argument
    end

    it '#pwm_set_mode(channel, mode, start = 1)' do
      is_expected.to respond_to(:pwm_set_mode).with(3).arguments
      is_expected.to respond_to(:pwm_set_mode).with(2).arguments
    end

    it '#pwm_set_range(channel, range)' do
      is_expected.to respond_to(:pwm_set_range).with(2).arguments
    end

    it '#pwm_set_data(channel, data)' do
      is_expected.to respond_to(:pwm_set_data).with(2).arguments
    end
  end
  
  context 'API for Spi' do
    it '#spi_set_data_mode(mode)' do
      is_expected.to respond_to(:spi_set_data_mode).with(1).argument
    end

    it '#spi_begin' do
      is_expected.to respond_to(:spi_begin).with(0).argument
    end

    it '#spi_end' do
      is_expected.to respond_to(:spi_end).with(0).argument
    end

    it '#spidev_out(array)' do
      is_expected.to respond_to(:spidev_out).with(1).argument
    end

    it '#spi_clock(clock_divider)' do
      is_expected.to respond_to(:spi_clock).with(1).argument
    end

    it '#spi_bit_order(order)' do
      is_expected.to respond_to(:spi_bit_order).with(1).argument
    end

    it '#spi_chip_select(cs)' do
      is_expected.to respond_to(:spi_chip_select).with(1).argument
    end

    it '#spi_chip_select_polarity(cs, active)' do
      is_expected.to respond_to(:spi_chip_select_polarity).with(2).arguments
    end

    it '#spi_transfer(byte)' do
      is_expected.to respond_to(:spi_transfer).with(1).argument
    end

    it '#spi_transfer_bytes(data)' do
      is_expected.to respond_to(:spi_transfer_bytes).with(1).arguments
    end
    
  end

  context 'API for I2C' do
    it '#i2c_begin' do
      is_expected.to respond_to(:i2c_begin).with(0).argument
    end

    it '#i2c_end' do
      is_expected.to respond_to(:i2c_end).with(0).argument
    end

    it '#i2c_allowed_clocks' do
      is_expected.to respond_to(:i2c_allowed_clocks).with(0).argument
    end

    it '#i2c_set_clock_divider(divider)' do
      is_expected.to respond_to(:i2c_set_clock_divider).with(1).argument
    end

    it '#i2c_set_clock(clock)' do
      is_expected.to respond_to(:i2c_set_clock).with(1).argument
    end

    it '#i2c_set_address(address)' do
      is_expected.to respond_to(:i2c_set_address).with(1).argument
    end

    it '#i2c_transfer_bytes(data)' do
      is_expected.to respond_to(:i2c_transfer_bytes).with(1).argument
    end

    it '#i2c_read_bytes(bytes)' do
      is_expected.to respond_to(:i2c_read_bytes).with(1).argument
    end

    it '#i2c_write(data_out, bytes)' do
      is_expected.to respond_to(:i2c_write).with(2).arguments
    end

    it '#i2c_read(data_in, bytes)' do
      is_expected.to respond_to(:i2c_read).with(2).arguments
    end
  end
end
