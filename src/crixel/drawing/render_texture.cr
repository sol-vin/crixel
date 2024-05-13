class Crixel::RenderTexture < Crixel::Sprite
  @render_texture : Raylib::RenderTexture2D

  def initialize(@texture : String, width : UInt32, height : UInt32)
    @render_texture = Raylib.load_render_texture(width, height)

    super(@texture)
  end

  def destroy
    Raylib.unload_render_texture(@render_texture)
    
    super
  end
end
