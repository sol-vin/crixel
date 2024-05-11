class Crixel::Sprite < Crixel::Basic
  include ISprite

  getter? ready = false

  def initialize(
    @texture = "default_rsrc/logo.png",
    @x = 0.0_f32,
    @y = 0.0_f32,
    width : Int32? = nil,
    height : Int32? = nil,
    offset : Raylib::Vector2 = Raylib::Vector2.zero
  )
    r_texture = Crixel::Assets.get_texture?(@texture)

    if r_texture
      @width = r_texture.not_nil!.width
      @height = r_texture.not_nil!.height
    else
      if w = width
        @width = w
      end

      if h = height
        @height = h
      end

      if width.nil? || height.nil?
        name = "sprite ready texture hook - #{rand(Int32::MAX)}"
        on_added(name: name) do
          if raylib_texture = Crixel::Assets.get_texture?(@texture)
            if @width == 0 && @height == 0
              @width = raylib_texture.width
              @height = raylib_texture.height
            end

            @ready = true
            delete_added(name)
          else
            raise "Texture was not ready :("
          end
        end
      elsif @width != 0 && @height != 0
        @ready = true
      end
    end
  end

  def draw
    if ready?
      draw_sprite
    end
  end
end
