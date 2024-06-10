
class Crixel::Quad::Leaf
  include IBody

  alias ID = UInt32 # TODO: Can change to UInt16?
  
  property? divided = false
  property nw : Leaf?
  property ne : Leaf?
  property sw : Leaf?
  property se : Leaf?

  getter id : ID 

  getter parent : Leaf? = nil

  getter current_depth = 0

  def initialize(parent : Leaf, @id, @x, @y, @width, @height)
    @parent = parent
    @current_depth = parent.current_depth + 1
  end

  def nw!
    @nw.not_nil!
  end

  def ne!
    @ne.not_nil!
  end

  def sw!
    @sw.not_nil!
  end

  def se!
    @se.not_nil!
  end

  def root?
    !parent
  end

  def insert(child : Basic) : Leaf
    # If we are divided, attempt to insert 
    if divided?
      return nw!.insert(child) if nw!.contains?(child)
      return ne!.insert(child) if ne!.contains?(child)
      return sw!.insert(child) if sw!.contains?(child)
      return se!.insert(child) if se!.contains?(child)
    end

    # Return ourself since we have to contain the child
    return self
  end

  def get_container(bounds : IBody) : Leaf
    if divided?
      return nw!.get_container(bounds) if nw!.contains?(bounds)
      return ne!.get_container(bounds) if ne!.contains?(bounds)
      return sw!.get_container(bounds) if sw!.contains?(bounds)
      return se!.get_container(bounds) if se!.contains?(bounds)
    end
    return self
  end

  def get_intersecting(bounds : IBody) : Set(Leaf)
    output = Set(Leaf).new
    if bounds.intersects?(self)
      output << self
      
      if self.divided?
        output.concat nw!.get_intersecting(bounds)
        output.concat ne!.get_intersecting(bounds)
        output.concat sw!.get_intersecting(bounds)
        output.concat se!.get_intersecting(bounds)
      end
    end
    output
  end

  def get_lineage : Set(Leaf)
    output = Set(Leaf).new
    output << self
    if p = parent
      output.concat p.get_lineage
    end
    output
  end

  def equals?(other : self)
    self.id == other.id
  end

  def draw(color : Color = Color::RED)
    self.draw_body(color)
    if divided?
      nw!.draw(color)
      ne!.draw(color)
      sw!.draw(color)
      se!.draw(color)
    end
  end
end