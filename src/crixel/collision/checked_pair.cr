  private struct CheckedPair
    getter b1 : Crixel::ID
    getter b2 : Crixel::ID

    def initialize(@b1, @b2)
    end

    # def equals?(other : CheckedPair)
    #   (b1 == other.b1 && b2 == other.b2) || 
    #   (b2 == other.b1 && b1 == other.b2)
    # end

    def hash
      b1.to_u64 ^ b2.to_u64 + ((b1.to_u64 ^ b2.to_u64) >> 32)
    end
  end