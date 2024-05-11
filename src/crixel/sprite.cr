class Crixel::Sprite < Crixel::Basic
  include ISprite

  def initialize(
      @texture = "default_rsrc/logo.png",
      @x = 0.0_f32,
      @y = 0.0_f32,
      width : Int32? = nil,
      height : Int32? = nil,
      offset : Raylib::Vector2 = Raylib::Vector2.zero
    )

    raylib_texture = Crixel::Assets.get_texture(@texture)
    raise "Texture not ready" unless if w = width
                                       @width = w
                                     else
                                       @width = raylib_texture.width
                                     end

    if h = height
      @height = h
    else
      @height = raylib_texture.height
    end
  end

  def draw
    draw_sprite
    draw_points(Raylib::RED)
  end
end
