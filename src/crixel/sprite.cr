class Crixel::Sprite < Crixel::Basic
  include ISprite
  include IInvCamera

  def initialize(
    @texture = "default_rsrc/logo.png",
    x = 0.0_f32,
    y = 0.0_f32,
    width = nil,
    height = nil
  )
    r_texture = Crixel::Assets.get_rtexture(@texture)
    @width = (width || r_texture.width).to_f32
    @height = (height || r_texture.height).to_f32
  end

  def draw
    draw_sprite
  end
end
