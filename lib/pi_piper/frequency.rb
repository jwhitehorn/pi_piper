module Frequency 

  def kilohertz
    self * 1000
  end

  def megahertz
    self * 1000000
  end

end

class Float
  include Frequency
end

class Integer
  include Frequency
end
