require "./iposition"
require "./isize"

module Crixel::IBody
  include IPosition
  include ISize

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

  def draw_body(tint : Color, fill = false)
    Rectangle.draw(x, y, width, height, tint, fill)
  end

  def intersects?(other : IBody) : Bool
    x < other.right &&
      right > other.x &&
      y < other.bottom &&
      bottom > other.y
  end
end
