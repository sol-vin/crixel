require "./iposition"
require "./isize"

module Crixel::IBody
  include IPosition
  include ISize

  alias Points = StaticArray(Vector2, 4)

  def to_rectangle : Rectangle
    Rectangle.new(
      x: x,
      y: y,
      width: width,
      height: height
    )
  end

  def rectangle=(other : IBody)
    @x = other.x
    @y = other.y
    @width = other.width
    @height = other.height
    other
  end

  def left
    x
  end

  def left=(x : Number)
    @x = x.to_f32
  end

  def right
    x + width
  end

  def right=(x : Number)
    @x = (x - width).to_f32
  end

  def bottom
    y + height
  end

  def bottom=(y : Number)
    @y = (y - height).to_f32
  end

  def top
    y
  end

  def top=(y : Number)
    @y = y.to_f32
  end

  def points : Points
    Points[
      Vector2.new(left, top),
      Vector2.new(right, top),
      Vector2.new(right, bottom),
      Vector2.new(left, bottom),
    ]
  end

  def draw_body(tint : Color, fill = false)
    Rectangle.draw(x, y, width, height, tint, fill)
  end

  def intersects?(other : IBody) : Bool
    intersects?(other.x, other.y, other.width, other.height)
  end

  def intersects?(ox, oy, owidth, oheight) : Bool
    Rectangle.intersects?(self.x, self.y, self.width, self.height, ox, oy, owidth, oheight)
  end

  def contains?(other : IBody)
    contains?(other.x, other.y, other.width, other.height)
  end

  def contains?(ox, oy, ow, oh)
    Rectangle.contains?(self.x, self.y, self.width, self.height, ox, oy, ow, oh)
  end

  def contains?(ox, oy) : Bool
    Rectangle.contains?(self.x, self.y, self.width, self.height, ox, oy)
  end

  def contains?(v : IPosition) : Bool
    contains?(v.x, v.y)
  end

  def contained_by?(ox, oy, ow, oh)
    Rectangle.contains?(ox, oy, ow, oh, self.x, self.y, self.width, self.height)
  end

  def center
    Vector2.new(x + width/2, y + height/2)
  end
end
