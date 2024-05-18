module Crixel::ISprite
  include IOBB
  
  property texture : String = "default_rsrc/logo.png"
  property src_rectangle : Rectangle = Rectangle.new
  property tint : Color::RGBA = Color::RGBA.new(r: 0xFF, b: 0xFF, g: 0xFF, a: 0xFF)

  def draw_sprite
    Sprite.draw(@texture, @src_rectangle, body, rotation, origin, tint)
  end
end
