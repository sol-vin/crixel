require "../modules/ibody"

struct Crixel::Rectangle
  def self.intersects?(x1, y1, w1, h1, x2, y2, w2, h2)
    intersects?(Vector2.new(x1, y1), Vector2.new(x1 + w1, y1 + h1), Vector2.new(x2, y2), Vector2.new(x2 + w2, y2 + h2))
  end

  def self.intersects?(a_min, a_max, b_min, b_max)
    a_min.x < b_max.x &&
    a_max.x > b_min.x &&
    a_min.y < b_max.y &&
    a_max.y > b_min.y
  end

  def self.contains?(x1, y1, w1, h1, x2, y2, w2, h2)
    contains?(Vector2.new(x1, y1), Vector2.new(x1 + w1, y1 + h1), Vector2.new(x2, y2), Vector2.new(x2 + w2, y2 + h2))
  end

  def self.contains?(a_min, a_max, b_min, b_max)
    a_min.x < b_min.x && a_min.y < b_min.y && a_max.x > b_max.x && a_max.y > b_max.y
  end

  def self.contains?(x1, y1, w1, h1, x2, y2)
    x1 < x2 && y1 < y2 && x1 + w1 > x2 && y1 + w1 > y2
  end

  include IBody

  def initialize(x : Number = 0.0_f32, y : Number = 0.0_f32, width : Number = 0.0_f32, height : Number = 0.0_f32)
    @x = x.to_f32
    @y = y.to_f32
    @width = width.to_f32
    @height = height.to_f32
  end

  def initialize(pos : Vector2, width : Number = 0.0_f32, height : Number = 0.0_f32)
    @x = pos.x
    @y = pos.y
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
