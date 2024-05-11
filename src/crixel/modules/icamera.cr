module Crixel::ICamera
  abstract def position : Raylib::Vector2
  abstract def offset : Raylib::Vector2
  abstract def rotation : Float32
  abstract def zoom : Float32
  abstract def bg_color : Raylib::Color

  def to_raylib : Raylib::Camera2D
    Raylib::Camera2D.new(
      target: position,
      offset: offset,
      rotation: -(rotation*Raylib::RAD2DEG).to_f32,
      zoom: zoom
    )
  end
end
