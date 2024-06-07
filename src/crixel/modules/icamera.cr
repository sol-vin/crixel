require "./iposition"
require "./irotation"

module Crixel::ICamera
  include IPosition
  include IRotation
  # TODO: Check if IOBB would be a better fit?
  #  - IOBB would allow one to transport a cameras vision area to the world easier?
  property camera_zoom : Float32 = 1.0_f32
  property camera_bg_color : Color::RGBA = Color::RGBA::CLEAR
  property camera_offset : Vector2 = Vector2.zero

  def includes?(x, y) : Bool
    world_space.intersects?(x, y)
  end

  def includes?(v2 : Vector2) : Bool
    world_space.intersects?(v2)
  end

  def to_world(x, y) : Vector2
    Raylib.get_screen_to_world_2d(Raylib::Vector2.new(x: x, y: y), to_rcamera).to_crixel
  end

  def world_space : Rectangle
    top_left = Raylib.get_screen_to_world_2d(Raylib::Vector2.new(x: 0, y: 0), to_rcamera)
    bottom_right = Raylib.get_screen_to_world_2d(Raylib::Vector2.new(x: Crixel.width, y: Crixel.height), to_rcamera)
    Rectangle.new(
      x: top_left.x,
      y: top_left.y,
      width: bottom_right.x,
      height: bottom_right.y
    )
  end

  def to_rcamera : Raylib::Camera2D
    Raylib::Camera2D.new(
      target: position.to_raylib + camera_offset.to_raylib,
      offset: origin.to_raylib,
      rotation: (rotation).to_f32,
      zoom: camera_zoom
    )
  end
end
