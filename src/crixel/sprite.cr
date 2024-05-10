class Crixel::Sprite < Crixel::Basic
  include ISprite


  def initialize(@texture = "default_rsrc/logo.png", width : Int32? = nil, height : Int32? = nil)
    raylib_texture = Crixel::Assets.get_texture(@texture)

    if w = width
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
  end
end