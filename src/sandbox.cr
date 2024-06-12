struct CheckedPair
  getter o1 : Int32
  getter o2 : Int32

  def initialize(@o1, @o2)
  end

  # def equals?(other : CheckedPair)
  #   (b1 == other.b1 && b2 == other.b2) || 
  #   (b2 == other.b1 && b1 == other.b2)
  # end

  def ==(other : CheckedPair)
    self.hash == other.hash
  end

  def hash
    x = (o1.to_u64 ^ o2.to_u64)
    y = (o2.to_u64 ^ o1.to_u64)
    x + (y >> 32)
  end
end

a = CheckedPair.new(1, 2)
b = CheckedPair.new(2, 1)

puts a == b

a = CheckedPair.new(10, 4)
b = CheckedPair.new(4, 11)

puts a == b