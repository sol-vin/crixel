require "./iposition"
require "./irotation"

module Crixel::ICamera
  include IPosition
  include IRotation
  property zoom : Float32 = 1.0_f32
  property bg_color : Color::RGBA = Color::RGBA::WHITE

  def to_rcamera : Raylib::Camera2D
    Raylib::Camera2D.new(
      target: position.to_raylib,
      offset: origin.to_raylib,
      rotation: (rotation).to_f32,
      zoom: zoom
    )
  end
end
