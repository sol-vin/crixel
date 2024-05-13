require "./iposition"
require "./irotation"

module Crixel::ICamera
  include IPosition
  include IRotation
  property zoom : Float32 = 1.0_f32
  property bg_color : Color::RGBA = Color::RGBA::CLEAR

  def follow(x, y, speed) 
    @position.x = ((position.x - x)/position.x) * speed
    @position.y = ((position.y - y)/position.y) * speed
  end

  def follow(pos : IPosition, speed) 
    @position.x = ((position.x - pos.x)/position.x) * speed
    @position.y = ((position.y - pos.y)/position.y) * speed
  end

  def follow(pos : Vector2, speed) 
    @position.x = ((position.x - pos.x)/position.x) * speed
    @position.y = ((position.y - pos.y)/position.y) * speed
  end

  def to_rcamera : Raylib::Camera2D
    Raylib::Camera2D.new(
      target: position.to_raylib,
      offset: origin.to_raylib,
      rotation: (rotation).to_f32,
      zoom: zoom
    )
  end
end
