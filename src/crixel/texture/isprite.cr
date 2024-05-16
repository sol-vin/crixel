module Crixel::ISprite
  include IOBB

  property texture : String = "default_rsrc/logo.png"
  setter src_rectangle : Rectangle? = nil
  property tint : Color::RGBA = Color::RGBA.new(r: 0xFF, b: 0xFF, g: 0xFF, a: 0xFF)

  def src_rectangle : Rectangle
    raylib_texture = Assets.get_rtexture(texture)
    @src_rectangle ? @src_rectangle.not_nil! : Rectangle.new(x: 0, y: 0, width: raylib_texture.width, height: raylib_texture.height)
  end

  def draw_sprite
    Sprite.draw(Assets.get_texture(texture), x, y, width, height, rotation, origin, src_rectangle, tint)
  end
end
