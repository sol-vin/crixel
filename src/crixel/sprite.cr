class Crixel::Sprite < Crixel::Basic
  include ISprite
  include IInvCamera

  def initialize(
    @texture = "default_rsrc/logo.png",
    @x = 0.0_f32,
    @y = 0.0_f32
  )
    r_texture = Crixel::Assets.get_texture(@texture)
    @width = r_texture.width
    @height = r_texture.height
  end

  def initialize(
    @x = 0.0_f32,
    @y = 0.0_f32,
    @width = 0.0_f32,
    @height = 0.0_f32
  )
    @texture = "default_rsrc/logo.png"
  end

  def draw
    draw_sprite
  end
end
