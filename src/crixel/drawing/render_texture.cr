class Crixel::RenderTexture < Crixel::Sprite
  @render_texture : Raylib::RenderTexture2D

  single_event Draw, rt : self

  def initialize(texture_name : String, width : UInt32, height : UInt32)
    asset_name = "@render_texture#{id}/#{texture_name}"
    @render_texture = Raylib.load_render_texture(width, height)
    Assets.add_texture(texture_name, @render_texture.texture)
    @render_texture.texture.on_destroyed(once: true) do
      destroy
    end
    super(asset_name)
  end

  def destroy
    if Raylib.texture_ready? @render_texture.texture
      Raylib.unload_render_texture(@render_texture)
    else
      RLGL.unload_framebuffer(@render_texture, id)
    end

    @render_texture = Raylib::RenderTexture2D.new

    super
  end
end
