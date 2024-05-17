struct Crixel::Frame
  include IOBB
  property texture : String = "default_rsrc/logo.png"

  property? enabled = true
  property duration : Time::Span = 0.1

  def draw_sprite
    Sprite.draw(Assets.get_texture(texture), x, y, width, height, rotation, origin, src_rectangle, tint)
  end
end