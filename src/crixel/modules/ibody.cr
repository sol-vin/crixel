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

  def draw_body(tint : Color, fill = false)
    Rectangle.draw(x, y, width, height, tint, fill)
  end
end
