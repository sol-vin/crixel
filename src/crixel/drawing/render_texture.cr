class Crixel::RenderTexture < Crixel::Sprite
  @render_texture : Raylib::RenderTexture2D

  def initialize(texture : String, width : UInt32, height : UInt32)
    @render_texture = Raylib.load_render_texture(width, height)
  end
end
