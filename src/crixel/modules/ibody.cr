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

  def left=(x)
    @x = x
  end

  def right
    x + width
  end

  def right=(x)
    @x = x - width
  end

  def bottom
    y + height
  end

  def bottom=(y)
    @y = y - height
  end

  def top
    y
  end

  def top=(y)
    @y = y
  end

  def points : Points
    Vector2{
      Vector2.new(left, top),
      Vector2.new(right, top),
      Vector2.new(right, bottom),
      Vector2.new(left, bottom),
    }
  end

  def draw_body(tint : Color, fill = false)
    Rectangle.draw(x, y, width, height, tint, fill)
  end

  def intersects?(x, y) : Bool
    self.x < x &&
      self.right > x &&
      self.y < y &&
      self.bottom > y
  end

  def intersects?(v2 : IPosition) : Bool
    self.x < v2.x &&
      self.right > v2.x &&
      self.y < v2.y &&
      self.bottom > v2.y
  end

  def intersects?(other : IBody) : Bool
    x < other.right &&
      right > other.x &&
      y < other.bottom &&
      bottom > other.y
  end

  def intersects?(x, y, width, height) : Bool
    self.x < x + width &&
      self.right > x &&
      self.y < y + height &&
      self.bottom > y
  end
end
