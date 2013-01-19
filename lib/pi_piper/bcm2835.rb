require 'ffi'

module PiPiper
  module Bcm2835
    extend FFI::Library
    ffi_lib File.dirname(__FILE__) + '/libbcm2835.img'

    attach_function :init, :bcm2835_init, [], :uint8
    attach_function :close, :bcm2835_close, [], :uint8

    attach_function :spi_begin,       :bcm2835_spi_begin,            [], :uint8
    attach_function :spi_end,         :bcm2835_spi_end,              [], :uint8
    attach_function :spi_transfer,    :bcm2835_spi_transfer,         [:uint8], :uint8
    attach_function :spi_transfernb,  :bcm2835_spi_transfernb,       [:pointer, :pointer, :uint], :void
    attach_function :spi_clock,       :bcm2835_spi_setClockDivider,  [:uint8], :void
    attach_function :spi_bit_order,   :bcm2835_spi_setBitOrder,      [:uint8], :void
    attach_function :spi_chip_select, :bcm2835_spi_chipSelect,       [:uint8], :void
    attach_function :spi_chip_select_polarity, 
                    :bcm2835_spi_setChipSelectPolarity,              [:uint8, :uint8], :void

    def self.spi_transfer_bytes(data)
      data_out = FFI::MemoryPointer.new(data.count) 
      data_in = FFI::MemoryPointer.new(data.count)
      (0..data.count-1).each { |i| data_out.put_uint8(i, data[i]) }

      spi_transfernb(data_out, data_in, data.count)

      (0..data.count-1).map { |i| data_in.get_uint8(i) }
    end

  end
end
