class Crixel::Camera
  property position : Raylib::Vector2 = Raylib::Vector2.new
  property offset : Raylib::Vector2 = Raylib::Vector2.new
  property rotation : Float32 = 0.0_f32
  property zoom : Float32 = 0.0_f32

  property bg_color : R::Color = R::Color.new

  def initialize(@position = Raylib::Vector2.new, @offset = Raylib::Vector2.new, @rotation = 0.0_f32, @zoom = 0.0_f32, @bg_color = R::Color.new)
  end

  def follow(x, y, speed)
    position.x = ((position.x - x)/position.x) * speed
    position.y = ((position.y - y)/position.y) * speed
  end

  def to_raylib : R::Camera2D
    R::Camera2D.new(
      target: position,
      offset: offset,
      rotation: rotation,
      zoom: zoom
    )
  end
end