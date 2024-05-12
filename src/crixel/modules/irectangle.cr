module Crixel::IRectangle
  include IPosition
  include ISize

  def rectangle : Rectangle
    Rectangle.new(
      x: x,
      y: y,
      width: width,
      height: height
    )
  end

  def draw_rectangle(tint : Color, fill = false)
    Rectangle.draw(x, y, width, height, tint, fill)
  end
end
