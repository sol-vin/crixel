class Crixel::Camera
  include ICamera

  def initialize(@x = 0.0_f32, @y = 0.0_f32, @origin = Vector2.zero, @rotation = 0.0_f32, @zoom = 1.0_f32, @bg_color = Color::RGBA.new)
  end
end
