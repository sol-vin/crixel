
struct Crixel::Quad::Leaf
  alias ID = UInt32
  getter id : ID
  getter? divided? = false

  getter nw : Leaf?
  getter ne : Leaf?
  getter sw : Leaf?
  getter se : Leaf?

  def initialize(@id)
  end

  def divide(nw_id, ne_id, sw_id, se_id)
    @divided = true
    @nw = Leaf.new(nw_id)
    @ne = Leaf.new(ne_id)
    @sw = Leaf.new(sw_id)
    @se = Leaf.new(se_id)
  end

  def nw!
    @nw
  end

  def ne!
    @nw
  end

  def sw!
    @nw
  end

  def se!
    @nw
  end
end