module Crixel::IPosition
  property x : Float32 = 0.0_f32
  property y : Float32 = 0.0_f32

  def position : Raylib::Vector2
    Raylib::Vector2.new(x: x, y: y)
  end
end
