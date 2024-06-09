require "./iposition"
require "./isize"

module Crixel::IBody
  include IPosition
  include ISize

  alias Points = StaticArray(Vector2, 4)

  def body : Rectangle
    Rectangle.new(
      x: x,
      y: y,
      width: width,
      height: height
    )
  end

  def body=(other : IBody)
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
      Vector2.new(left, bottom)
    ]
  end

  def draw_body(tint : Color, fill = false)
    Rectangle.draw(x, y, width, height, tint, fill)
  end

  def intersects?(other : IBody) : Bool
    intersects?(other.x, other.y, other.width, other.height)
  end

  def intersects?(x, y, width, height) : Bool
    self.x < x + width &&
      self.right > x &&
      self.y < y + height &&
      self.bottom > y
  end

  def contains?(other : IBody)
    contains?(other.x, other.y, other.width, other.height)
  end

  def contains?(x, y, w, h)
    left < x && top < y && right > x + w && bottom > y + h
  end

  def contains?(x, y) : Bool
    self.x < x &&
      self.right > x &&
      self.y < y &&
      self.bottom > y
  end

  def contains?(v : IPosition) : Bool
    contains?(v.x, v.y)
  end

  def contained_by?(x, y, w, h)
    x < self.left && y < self.top && x + w > self.right && y + h > self.bottom
  end

  def center
    Vector2.new(x + width/2, y + height/2)
  end
end
