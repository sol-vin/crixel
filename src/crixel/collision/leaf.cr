
class Crixel::Quad::Leaf
  include IBody

  alias ID = UInt32 # TODO: Can change to UInt16?
  
  property? divided = false

  property nw : Leaf?
  property ne : Leaf?
  property sw : Leaf?
  property se : Leaf?


  getter current_depth = 0

  getter children = Set(Crixel::ID).new

  def initialize(depth, @x, @y, @width, @height)
    @current_depth = depth
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

  def merge
    if divided?
      nw!.merge
      ne!.merge
      sw!.merge
      se!.merge

      @children.concat nw!.children
      @children.concat ne!.children
      @children.concat sw!.children
      @children.concat se!.children
    end
  end

  def subdivide
    @divided = true
    w = width/2
    h = height/2
    @nw = Leaf.new(current_depth+1, x, y, w, h)
    @ne = Leaf.new(current_depth+1, x + w, y, w, h)
    @sw = Leaf.new(current_depth+1, x, y + h, w, h)
    @se = Leaf.new(current_depth+1, x + w, y + h, w, h)
  end

  # Returns what leaf this object should insert into
  def get_container(child : Basic) : Leaf
    return get_container(child.as(IBody))
  end

  # Returns what leaf contains this bounds
  def get_container(bounds : IBody) : Leaf
    if divided?
      return nw!.get_container(bounds) if nw!.contains?(bounds)
      return ne!.get_container(bounds) if ne!.contains?(bounds)
      return sw!.get_container(bounds) if sw!.contains?(bounds)
      return se!.get_container(bounds) if se!.contains?(bounds)
    end
    return self
  end

  def leafs : StaticArray(Leaf, 4)
    return Leaf[nw!, ne!, sw!, se!] if divided?
    raise("leafs called but not divided :(")
  end

  def leafs? : StaticArray(Leaf, 4)?
    return Leaf[nw!, ne!, sw!, se!] if divided?
    return nil
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