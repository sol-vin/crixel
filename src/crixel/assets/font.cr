class Crixel::Assets::Font < Crixel::Asset
  getter name : String
  property rfont : Raylib::Font

  def initialize(@name, @rfont)
  end
end

module Crixel::Assets
  SUPPORTED_FONTS = %w[TTF OTF]
  @@fonts = {} of String => Font

  DEFAULT_FONT_SIZE = 40

  add_consumer do |path, io, size|
    full_path = Path.new(path)
    extension = full_path.extension.downcase
    font_size = nil
    if match = full_path.basename.match(/^.+\.(\d+)\..+$/)
      font_size = match[1].to_i
    end
    
    if SUPPORTED_FONTS.any? { |ext| extension.upcase[1..] == ext }
      content = io.gets_to_end
      font = Raylib.load_font_from_memory(extension, content, size, font_size || DEFAULT_FONT_SIZE, Pointer(Int32).null, 0)
      raise "Font invalid" unless Raylib.font_ready?(font)
      add_font Font.new(path, font)
      true
    else
      false
    end
  end

  def self.add_font(font : Font)
    if @@fonts[font.name]?
      emit Asset::Changed, @@fonts[font.name], font
      @@fonts[font.name].rfont = font.rfont
    else
      @@fonts[font.name] = font
    end
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
