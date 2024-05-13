

module Crixel::Assets
  alias ConsumerCallback = Proc(String, IO, Int32, Bool)
  SUPPORTED_TEXTURES = %w[PNG BMP TGA JPG GIF QOI PSD DDS HDR KTX ASTC PKM PVR]
  SUPPORTED_FONTS    = %w[TTF OTF]

  class_property default_font_size = 12

  @@textures = {} of String => Raylib::Texture2D
  @@fonts = {} of String => Raylib::Font

  @@consumers : Array(ConsumerCallback) = [] of ConsumerCallback

  event ::Crixel::Asset::Destroyed, asset : Crixel::Asset

  event Unload
  event PreSetup
  event Setup
  event PostSetup

  # Tracks when an asset has been destroyed

  def self.add_consumer(&block : ConsumerCallback)
    @@consumers << block
  end

  add_consumer do |path, io, size|
    extension = Path.new(path).extension.downcase
    if SUPPORTED_TEXTURES.any? { |ext| extension.upcase[1..] == ext }
      content = io.gets_to_end
      image = Raylib.load_image_from_memory(extension, content, size)
      texture = Raylib.load_texture_from_image(image)
      raise "Texture invalid" unless Raylib.texture_ready?(texture)
      @@textures[path] = texture
      true
    else
      false
    end
  end

  add_consumer do |path, io, size|
    extension = Path.new(path).extension.downcase
    if SUPPORTED_FONTS.any? { |ext| extension.upcase[1..] == ext }
      content = io.gets_to_end
      font = Raylib.load_font_from_memory(extension, content, size, @@default_font_size, Pointer(Int32).null, 0)
      raise "Font invalid" unless Raylib.font_ready?(font)
      @@fonts[path] = font
      true
    else
      false
    end
  end

  def self.run_consumers(path : String, io : IO, size : Int)
    @@consumers.any? do |consumer|
      consumer.call(path, io, size)
    end
  end



  def self.setup
    emit PreSetup
    emit Setup
    emit PostSetup
  end

  def self.load(path : String, io : IO, size : Int32)
    raise "Cannot load before window is initialized: Try running asset loading methods from an `on Crixel::Assets::Setup` callback" unless Crixel.running?
    run_consumers(path, io, size)
  end

  def self.load_from_path(filename : String)
    File.open(filename) do |file|
      load(filename, file, file.size.to_i32)
    end
  end

  def self.add_texture(name : String, texture : Raylib::Texture2D)
    @@textures[name] = texture
  end

  def self.get_texture(name)
    @@textures[name]
  end

  def self.get_texture?(name)
    @@textures[name]?
  end

  def self.add_font(name : String, font : Raylib::Font)
    @@fonts[name] = font
  end

  def self.get_font(name)
    @@fonts[name]
  end

  def self.get_font?(name)
    @@fonts[name]?
  end

  def self.unload_texture(name)
  end

  def self.delete_texture(name)
  end

  def self.unload
    @@textures.values.each do |t|
      Raylib.unload_texture(t)
      emit Asset::Destroyed, t.as(Asset)
    end
    @@textures.clear

    @@fonts.values.each do |f|
      Raylib.unload_font(f)
      emit Asset::Destroyed, f.as(Asset)
    end
    @@fonts.clear

    emit Unload
  end
end

module Crixel::Asset
end

struct Raylib::Texture2D
  include Crixel::Asset
end

struct Raylib::Font
  include Crixel::Asset
end