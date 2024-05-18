module Crixel::IInvCamera
  include ICamera

  def to_rcamera : Raylib::Camera2D
    Raylib::Camera2D.new(
      target: position.to_raylib,
      offset: origin.to_raylib,
      rotation: -(rotation*Raylib::RAD2DEG).to_f32,
      zoom: camera_zoom
    )
  end
end
