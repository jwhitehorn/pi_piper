module PiPiper
  module DeviceDrivers
    # The LCD 1602 2004 is widely used i2c adapter for LCD displays.
    # Often there are prepacked LCD displays with this adapter already
    # soldered on.
    #
    # Example:
    # # Initialize display at I2C address 0x3f
    # lcd = PiPiper::DeviceDrivers::Lcd16022004.new(0x3f)
    # # Turn on the backlight
    # lcd.set_backlight(true)
    # # Write some text to the first line
    # lcd.write_text("Hello world", 1)

    class Lcd16022004
      # Commands
      CMD_CLEARDISPLAY = 0x01
      CMD_RETURNHOME = 0x02
      CMD_ENTRYMODESET = 0x04
      CMD_DISPLAYCONTROL = 0x08
      CMD_CURSORSHIFT = 0x10
      CMD_FUNCTIONSET = 0x20
      CMD_SETCGRAMADDR = 0x40
      CMD_SETDDRAMADDR = 0x80

      # Flags for display entry mode
      ENTRYMODE_ENTRYRIGHT = 0x00
      ENTRYMODE_ENTRYLEFT = 0x02
      ENTRYMODE_ENTRYSHIFTINCREMENT = 0x01
      ENTRYMODE_ENTRYSHIFTDECREMENT = 0x00

      # Flags for display on/off control
      DISPLAYCONTROL_DISPLAYON = 0x04
      DISPLAYCONTROL_DISPLAYOFF = 0x00
      DISPLAYCONTROL_CURSORON = 0x02
      DISPLAYCONTROL_CURSOROFF = 0x00
      DISPLAYCONTROL_BLINKON = 0x01
      DISPLAYCONTROL_BLINKOFF = 0x00

      # Flags for display/cursor shift
      LCD_DISPLAYMOVE = 0x08
      LCD_CURSORMOVE = 0x00
      LCD_MOVERIGHT = 0x04
      LCD_MOVELEFT = 0x00

      # Flags for function set
      LCD_8BITMODE = 0x10
      LCD_4BITMODE = 0x00
      LCD_2LINE = 0x08
      LCD_1LINE = 0x00
      LCD_5x10DOTS = 0x04
      LCD_5x8DOTS = 0x00

      # Flags for backlight control
      LCD_BACKLIGHT = 0x08
      LCD_NOBACKLIGHT = 0x00

      # Row selectors
      ROW_SELECTOR = [0x80, 0xC0, 0x94, 0xD4]

      # Control bits
      ENABLE = 0b00000100
      READWRITE= 0b00000010
      REGISTER_SELECT = 0b00000001

      def initialize(i2c_address, options = {})
        @i2c_address = i2c_address

        dots_per_character = case options[:dots_per_character]
        when nil
        when :"5x8"
          LCD_5x8DOTS
        when :"5x10"
          LCD_5x10DOTS
        end

        send_command(0x03)
        send_command(0x03)
        send_command(0x03)
        send_command(0x02)

        send_command(CMD_FUNCTIONSET | LCD_2LINE | dots_per_character | LCD_4BITMODE)
        send_command(CMD_DISPLAYCONTROL | DISPLAYCONTROL_DISPLAYON)
        send_command(CMD_CLEARDISPLAY)
        send_command(CMD_ENTRYMODESET | ENTRYMODE_ENTRYLEFT)
        sleep(0.2)
      end

      def strobe(data)
        I2C.begin do
          write(data: [data | ENABLE | LCD_BACKLIGHT], to: @i2c_address)
          sleep(0.0005)
          write(data: [((data & ~ENABLE) | LCD_BACKLIGHT)], to: @i2c_address)
          sleep(0.0001)
        end
      end

      def write_four_bits(data)
        I2C.begin do
          write(data: [data | LCD_BACKLIGHT], to: @i2c_address)
        end
        strobe(data)
      end

      def send_command(cmd, mode = 0)
        write_four_bits(mode | (cmd & 0xF0))
        write_four_bits(mode | ((cmd << 4) & 0xF0))
      end

      def set_backlight(on)
        I2C.begin do
          write(data: [on ? LCD_BACKLIGHT : LCD_NOBACKLIGHT], to: @i2c_address)
        end
      end

      def clear()
        send_command(CMD_CLEARDISPLAY)
        send_command(CMD_RETURNHOME)
      end

      def write_text(text, row_number)
        if 1..4.include?(row_number)
          send_command(ROW_SELECTOR[row_number - 1])
          text.each_byte do |byte|
            send_command(byte, REGISTER_SELECT)
          end
          true
        else
          false
        end
      end
    end
  end
end