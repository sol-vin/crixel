struct Crixel::Circle
  property x : Float32 = 0.0_f32
  property y : Float32 = 0.0_f32
  property radius : Float32 = 0.0_f32

  def initialize(x : Number = 0.0_f32, y : Number = 0.0_f32, radius : Number = 0.0_f32)
    @x = x.to_f32
    @y = y.to_f32
    @radius = radius.to_f32
  end

  def draw(tint : Color = Color::RGBA::WHITE, fill = false)
    Circle.draw(x, y, radius, tint, fill)
  end

  def self.draw(x, y, radius, tint : Color = Color::RGBA::WHITE, fill = false)
    if fill
      Raylib.draw_circle(x, y, radius, tint.to_rgba.to_raylib)
    else
      Raylib.draw_circle_lines(x, y, radius, tint.to_rgba.to_raylib)
    end
  end
end