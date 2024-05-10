module Crixel::ISprite
  include IRectangle
  include IRotation

  # TODO: Make a new texture class to hold this kind of info
  property texture : String = "default_rsrc/logo.png"
  setter source_rectangle : Raylib::Rectangle? = nil
  property tint : Raylib::Color = Raylib::Color.new(r: 0xFF, b: 0xFF, g: 0xFF, a: 0xFF)
  property offset : Raylib::Vector2 = Raylib::Vector2.zero

  def source_rectangle : Raylib::Rectangle
    raylib_texture = Crixel::Assets.get_texture(texture)
    @source_rectangle ? @source_rectangle.not_nil! : Raylib::Rectangle.new(x: 0, y: 0, width: raylib_texture.width, height: raylib_texture.height)
  end

  def draw_sprite
    Raylib.draw_texture_pro(Crixel::Assets.get_texture(texture), source_rectangle, rectangle, origin, rotation, tint)
  end
end