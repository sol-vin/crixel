require "./iposition"
require "./irotation"

module Crixel::ICamera
  include IPosition
  include IRotation
  property zoom : Float32 = 1.0_f32
  property bg_color : Color::RGBA = Color::RGBA::CLEAR
  property offset : Vector2 = Vector2.zero

  def follow(x, y, speed = 1.0_f32)
    distance = Vector2.new((x - @x), (y - @y))
    @x += distance.x * speed
    @y += distance.y * speed
  end

  def follow(pos : IPosition, speed = 1.0_f32)
    follow(pos.x, pos.y, speed)
  end

  def follow(pos : Vector2, speed = 1.0_f32)
    follow(pos.x, pos.y, speed)
  end

  def to_rcamera : Raylib::Camera2D
    Raylib::Camera2D.new(
      target: position.to_raylib + offset.to_raylib,
      offset: origin.to_raylib,
      rotation: (rotation).to_f32,
      zoom: zoom
    )
  end
end
