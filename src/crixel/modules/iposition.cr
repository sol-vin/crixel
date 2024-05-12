module Crixel::IPosition
  property x : Float32 = 0.0_f32
  property y : Float32 = 0.0_f32

  def position : Vector2
    Vector2.new(x: x, y: y)
  end

  def position=(v2 : Vector2)
    position = v2
  end

  def draw_position(tint : Color, radius = 1)
    Raylib.draw_circle(x, y, radius, tint.to_rgba.to_raylib)
  end
end
