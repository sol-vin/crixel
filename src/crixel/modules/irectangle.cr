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
end
