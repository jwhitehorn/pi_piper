module PiPiper
  module PinValues
    GPIO_PUD_OFF = 0
    GPIO_PUD_DOWN = 1
    GPIO_PUD_UP = 2

    GPIO_HIGH = 1
    GPIO_LOW  = 0

    GPIO_FSEL_INPT = 0b000
    GPIO_FSEL_OUTP = 0b001
    GPIO_FSEL_ALT0 = 0b100
    GPIO_FSEL_ALT1 = 0b101
    GPIO_FSEL_ALT2 = 0b110
    GPIO_FSEL_ALT3 = 0b111
    GPIO_FSEL_ALT4 = 0b011
    GPIO_FSEL_ALT5 = 0b010
    GPIO_FSEL_MASK = 0b111


    PWM_PIN = {
        12 => {:channel => 0, :alt_fun => GPIO_FSEL_ALT0},
        13 => {:channel => 1, :alt_fun => GPIO_FSEL_ALT0},
        18 => {:channel => 0, :alt_fun => GPIO_FSEL_ALT5},
        19 => {:channel => 1, :alt_fun => GPIO_FSEL_ALT5},
        40 => {:channel => 0, :alt_fun => GPIO_FSEL_ALT0},
        41 => {:channel => 1, :alt_fun => GPIO_FSEL_ALT0},
        45 => {:channel => 1, :alt_fun => GPIO_FSEL_ALT0},
        52 => {:channel => 0, :alt_fun => GPIO_FSEL_ALT1},
        53 => {:channel => 1, :alt_fun => GPIO_FSEL_ALT1}
    }

    PWM_MODE = [:balanced, :markspace]
  end
end
