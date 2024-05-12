class Crixel::Camera
  include ICamera

  property position : Vector2 = Vector2.zero
  property offset : Vector2 = Vector2.zero
  property rotation : Float32 = 0.0_f32
  property zoom : Float32 = 1.0_f32

  property bg_color : Color::RGBA = Color::RGBA.new

  def initialize(@position = Vector2.zero, @offset = Vector2.zero, @rotation = 0.0_f32, @zoom = 1.0_f32, @bg_color = Color::RGBA.new)
  end

  def follow(x, y, speed)
    position.x = ((position.x - x)/position.x) * speed
    position.y = ((position.y - y)/position.y) * speed
  end
end
