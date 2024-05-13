class Crixel::Assets::Font < Crixel::Asset
  getter name : String
  getter font : Raylib::Font

  def initialize(@name, @font)
  end
end
