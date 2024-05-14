class Crixel::Assets::Font < Crixel::Asset
  getter name : String
  getter rfont : Raylib::Font

  def initialize(@name, @rfont)
  end
end

module Crixel::Assets
  SUPPORTED_FONTS = %w[TTF OTF]
  @@fonts = {} of String => Font

  DEFAULT_FONT_SIZE = 20

  add_consumer do |path, io, size|
    extension = Path.new(path).extension.downcase
    if SUPPORTED_FONTS.any? { |ext| extension.upcase[1..] == ext }
      content = io.gets_to_end
      font = Raylib.load_font_from_memory(extension, content, size, DEFAULT_FONT_SIZE, Pointer(Int32).null, 0)
      raise "Font invalid" unless Raylib.font_ready?(font)
      add_font Font.new(path, font)
      true
    else
      false
    end
  end

  def self.add_font(font : Font)
    emit Asset::Changed, font if @@fonts[font.name]?
    @@fonts[font.name] = font
  end

  def self.get_font(name)
    @@fonts[name]
  end

  def self.get_font?(name)
    @@fonts[name]?
  end

  def self.get_rfont(name)
    @@fonts[name].rfont
  end

  def self.get_rfont?(name)
    @@fonts[name]?.try(&.rfont)
  end

  on(Unload) do
    @@fonts.values.each do |f|
      Raylib.unload_font(f.rfont)
      emit Asset::Destroyed, f
    end
    @@fonts.clear
  end
end
