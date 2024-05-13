struct Crixel::Line
  property x1 : Float32 = 0.0_f32
  property y1 : Float32 = 0.0_f32
  property x2 : Float32 = 0.0_f32
  property y2 : Float32 = 0.0_f32

  def p1
    Vector2.new(x1, y1)
  end

  def p2
    Vector2.new(x2, y2)
  end

  def initialize(x1 : Number = 0.0_f32, y1 : Number = 0.0_f32, x2 : Number = 0.0_f32, y2 : Number = 0.0_f32)
    @x1 = x1.to_f32
    @y1 = y1.to_f32
    @x2 = x2.to_f32
    @y2 = y2.to_f32
  end

  def draw(thickness : Number = 1, tint : Color = Color::RGBA::WHITE, fill = false)
    Line.draw(x1, y1, x2, y2, thickness, tint, fill)
  end

  def self.draw(x1, y1, x2, y2, thickness : Number = 1, tint : Color = Color::RGBA::WHITE, fill = false)
    Raylib.draw_line_ex(Raylib::Vector2.new(x: x1, y: y1), Raylib::Vector2.new(x: x2, y: y2), thickness.to_f, tint.to_rgba.to_raylib)
  end
end
