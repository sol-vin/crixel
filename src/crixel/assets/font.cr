class Crixel::Assets::Font < Crixel::Asset
  getter name : String
  getter rfont : Raylib::Font

  def initialize(@name, @rfont)
  end
end
