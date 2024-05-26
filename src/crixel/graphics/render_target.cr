require "./sprite"

class Crixel::RenderTarget < Crixel::Sprite
  @render_texture : Raylib::RenderTexture2D

  getter? currently_drawing = false

  getter camera : ICamera = Camera.new

  single_event Draw, rt : self, total_time : Time::Span, elapsed_time : Time::Span

  def initialize(texture_name : String = "", x = 0, y = 0, width : UInt32 = 0, height : UInt32 = 0, unload_on_destroy = true)
    texture_name = "@RenderTarget#{id}@" if texture_name.empty?
    @render_texture = Raylib.load_render_texture(width, height)
    texture = Assets::Texture.new(texture_name, @render_texture.texture)
    Assets.add_texture texture

    texture.on_destroyed(once: true) do
      destroy
    end

    self.on_destroyed do
      if Raylib.texture_ready?(@render_texture.texture) && unload_on_destroy
        Raylib.unload_render_texture(@render_texture)
        Assets.remove_texture(name, unload: false)
      elsif unload_on_destroy
        Assets.remove_texture(name, unload: true)
      else
        RLGL.unload_framebuffer(@render_texture.id)
      end

      @render_texture = Raylib::RenderTexture2D.new
    end
    super(texture: texture_name, x: x, y: y, width: width, height: height)
  end

  def clear_background(color : Color::RGBA)
    if currently_drawing?
      Raylib.clear_background(color.to_raylib)
    else
      # Doing this is safer than trying to mess with the camera modes and hoping it works right
      image = Raylib.gen_image_color(@width.to_i, @height.to_i, color.to_raylib)
      r_texture = Assets.get_rtexture(@texture)
      Raylib.update_texture(r_texture, image.data)
      Raylib.unload_image image
    end
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
    if visible?
      @currently_drawing = true
      Crixel.start_2d_mode(camera)
      Raylib.begin_texture_mode(@render_texture)
      emit Draw, self, total_time, elapsed_time
      Raylib.end_texture_mode
      Crixel.stop_2d_mode

      @currently_drawing = false
      super
    end
  end
end
