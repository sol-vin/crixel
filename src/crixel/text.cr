class Crixel::Text < Crixel::Basic
  def self.measure_text(font : String, text : String, height : Float32, spacing : Float32 = 0.0_f32)
    Raylib.measure_text_ex(Assets.get_rfont(font), text, height, spacing)
  end

  include IOBB

  property font : String = "default_rsrc/font.ttf"
  getter text : String = ""
  getter? dirty = false
  property spacing : Float32 = 0.0_f32
  property tint : Color::RGBA = Color::RGBA::WHITE
  @height = 12

  @render_texture = Raylib::RenderTexture2D.new

  def initialize(@text = "", text_size = 12, @font = "default_rsrc/font.ttf", width_limit = nil, @tint = Color::RGBA::WHITE)
    @height = text_size
    if width_limit
      @width = width_limit.to_f32
    else
      @width = -1.0_f32
    end
    self.text = text
    self.on_destroyed { Raylib.unload_render_texture(@render_texture) }
  end

  private def _remake_texture
    if Raylib.render_texture_ready?(@render_texture)
      Raylib.unload_render_texture(@render_texture)
    end

    size = self.text_size

    @render_texture = Raylib.load_render_texture(size.x.to_i, size.y.to_i)

    Crixel.start_2d_mode
    Raylib.begin_texture_mode(@render_texture)
    Raylib.clear_background(Color::RGBA::CLEAR.to_raylib)

    Raylib.draw_text_pro(Assets.get_rfont(font), text, Raylib::Vector2.zero, Raylib::Vector2.zero, 0, height, spacing, tint.to_raylib)
    Raylib.end_texture_mode
    Crixel.stop_2d_mode
  end

  def text=(t)
    @dirty = true if @text != t
    @text = t
  end

  # Alias of IRectangle#width
  def limit_width(w)
    @width = w
  end

  def unlimit_width
    @width = -1.0_f32
  end

  def limit_width?
    @width > 0
  end

  def text_size
    self.class.measure_text(font, text, height, spacing).to_crixel
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
    if visible?
      _remake_texture if dirty?
      size = Vector2.zero
      src = Rectangle.new

      if limit_width?
        text_height = self.text_size.y
        size = Vector2.new(@width, text_height)
        src = Rectangle.new(0, 0, @width, -text_height)
      else
        size = self.text_size
        src = Rectangle.new(0, 0, size.x, -size.y)
      end

      Sprite.draw(@render_texture.texture, x, y, size, rotation, origin, src, tint)
    end
  end
end
