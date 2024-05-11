module Crixel::IRectangle
  include IPosition
  include ISize

  def rectangle : Raylib::Rectangle
    Raylib::Rectangle.new(
      x: x,
      y: y,
      width: width,
      height: height
    )
  end
end
