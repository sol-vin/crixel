module Crixel::IRectangle
  include IPosition

  property width : Int32 = 0
  property height : Int32 = 0

  def rectangle : Raylib::Rectangle
    Raylib::Rectangle.new(
      x: x,
      y: y,
      width: width,
      height: height
    )
  end
end