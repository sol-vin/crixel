require "./isprite"
struct Crixel::Frame
  include ISprite

  property? enabled = true
  property duration : Time::Span = Time::Span.new(seconds: 1)

  def draw_sprite
    # Sprite.draw(Assets.get_texture(texture), x, y, width, height, rotation, origin, src_rectangle, tint)
  end
end