module Crixel::ISprite
  property texture : String = "default_rsrc/logo.png"
  property src_rectangle : Rectangle = Rectangle.new
  property tint : Color::RGBA = Color::RGBA.new(r: 0xFF, b: 0xFF, g: 0xFF, a: 0xFF)
end
