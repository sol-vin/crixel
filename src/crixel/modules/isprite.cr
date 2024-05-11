module Crixel::ISprite
  include IOBB

  # TODO: Make a new texture class to hold this kind of info
  property texture : String = "default_rsrc/logo.png"
  setter source_rectangle : Raylib::Rectangle? = nil
  property tint : Raylib::Color = Raylib::Color.new(r: 0xFF, b: 0xFF, g: 0xFF, a: 0xFF)

  def source_rectangle : Raylib::Rectangle
    raylib_texture = Assets.get_texture(texture)
    @source_rectangle ? @source_rectangle.not_nil! : Raylib::Rectangle.new(x: 0, y: 0, width: raylib_texture.width, height: raylib_texture.height)
  end

  def draw_sprite
    r_texture = Assets.get_texture(texture)
    raise "Cannot open texture" unless Raylib.texture_ready? r_texture
    Raylib.draw_texture_pro(r_texture, source_rectangle, dst_rectangle, origin, rotation, tint)
  end
end
