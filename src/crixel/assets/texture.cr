class Crixel::Assets::Texture < Crixel::Asset
  getter name : String
  getter texture : Raylib::Texture2D

  def initialize(@name, @texture)
  end
end
