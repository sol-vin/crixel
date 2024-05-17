module Crixel::ISprite
  include IOBB

  property src_rectangle : Rectangle = Rectangle.new
  property tint : Color::RGBA = Color::RGBA.new(r: 0xFF, b: 0xFF, g: 0xFF, a: 0xFF)
  property offset : Vector2 = Vector2.zero

  def draw_sprite
  end
end
