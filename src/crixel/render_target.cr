class Crixel::RenderTarget < Crixel::Sprite
  @render_texture : Raylib::RenderTexture2D

  getter? currently_drawing = false

  getter camera : ICamera? = nil

  single_event Draw, rt : self

  def initialize(texture_name : String, x = 0, y = 0, width : UInt32 = 0, height : UInt32 = 0)
    name = "@Crixel::RenderTarget@#{texture_name}"
    @render_texture = Raylib.load_render_texture(width, height)
    texture = Assets::Texture.new(name, @render_texture.texture)
    Assets.add_texture(name, texture)

    texture.on_destroyed(once: true) do
      destroy
    end
    super(texture: name, x: x, y: y, width: width, height: height)
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

  def draw
    Raylib.end_mode_2d
    @currently_drawing = true

    Raylib.begin_texture_mode(@render_texture)
    if camera
      c = camera.not_nil!
      Raylib.begin_mode_2d(c.to_rcamera)
      clear_background(c.bg_color)
    end
    emit Draw, self
    Raylib.end_mode_2d if camera
    Raylib.end_texture_mode
    @currently_drawing = false

    Raylib.begin_mode_2d(Crixel.running_state.camera.to_rcamera)
    super
  end

  def destroy
    if Raylib.texture_ready? @render_texture.texture
      Raylib.unload_render_texture(@render_texture)
    else
      RLGL.unload_framebuffer(@render_texture.id)
    end

    @render_texture = Raylib::RenderTexture2D.new

    super
  end
end
