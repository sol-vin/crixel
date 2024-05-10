class Crixel::Camera
  include ICamera

  property position : Raylib::Vector2 = Raylib::Vector2.zero
  property offset : Raylib::Vector2 = Raylib::Vector2.zero
  property rotation : Float32 = 0.0_f32
  property zoom : Float32 = 1.0_f32

  property bg_color : Raylib::Color = Raylib::Color.new

  def initialize(@position = Raylib::Vector2.zero, @offset = Raylib::Vector2.zero, @rotation = 0.0_f32, @zoom = 1.0_f32, @bg_color = Raylib::Color.new)
  end

  def follow(x, y, speed)
    position.x = ((position.x - x)/position.x) * speed
    position.y = ((position.y - y)/position.y) * speed
  end
end
