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

  def contains?(other : IBody)
    other.points.all? {|v| v.x >= left && v.x <= right && v.y >= top && v.y <= bottom}
  end

  def contains?(x, y) : Bool
    self.x < x &&
      self.right > x &&
      self.y < y &&
      self.bottom > y
  end

  def contains?(v2 : IPosition) : Bool
    self.x < v2.x &&
      self.right > v2.x &&
      self.y < v2.y &&
      self.bottom > v2.y
  end

  def center
    Vector2.new(x + width/2, y + height/2)
  end
end
