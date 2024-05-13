class Crixel::RenderTarget < Crixel::Sprite
  @render_texture : Raylib::RenderTexture2D

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

  def draw
    Raylib.end_mode_2d
    Raylib.begin_texture_mode(@render_texture)
    emit Draw, self
    Raylib.end_texture_mode
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
