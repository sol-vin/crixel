require "../modules/ibody"

struct Crixel::Rectangle
  include IBody

  def initialize(x : Number = 0.0_f32, y : Number = 0.0_f32, width : Number = 0.0_f32, height : Number = 0.0_f32)
    @x = x.to_f32
    @y = y.to_f32
    @width = width.to_f32
    @height = height.to_f32
  end

  def body : IBody
    return self
  end

  def to_raylib : Raylib::Rectangle
    Raylib::Rectangle.new(
      x: x,
      y: y,
      width: width,
      height: height
    )
  end

  def draw(tint : Color = Color::RGBA::WHITE, fill = false)
    draw_body(tint, fill)
  end

  def self.draw(x, y, width, height, tint : Color = Color::RGBA::WHITE, fill = false)
    if fill
      Raylib.draw_rectangle(x, y, width, height, tint.to_rgba.to_raylib)
    else
      Raylib.draw_rectangle_lines(x, y, width, height, tint.to_rgba.to_raylib)
    end
  end
end
