module Crixel::ICamera
  abstract def position : Vector2
  abstract def offset : Vector2
  abstract def rotation : Float32
  abstract def zoom : Float32
  abstract def bg_color : Color::RGBA

  def to_raylib : Raylib::Camera2D
    Raylib::Camera2D.new(
      target: position.to_raylib,
      offset: offset.to_raylib,
      rotation: (rotation*Raylib::RAD2DEG).to_f32,
      zoom: zoom
    )
  end
end
