class Crixel::Assets::Texture < Crixel::Asset
  getter name : String
  getter rtexture : Raylib::Texture2D

  def initialize(@name, @rtexture)
  end
end
