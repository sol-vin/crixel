class Crixel::Assets::Texture < Crixel::Asset
  getter name : String
  getter rtexture : Raylib::Texture2D

  def initialize(@name, @rtexture)
  end
end

module Crixel::Assets
  SUPPORTED_TEXTURES = %w[PNG BMP TGA JPG GIF QOI PSD DDS HDR KTX ASTC PKM PVR]
  @@textures = {} of String => Texture

  add_consumer do |path, io, size|
    extension = Path.new(path).extension.downcase
    if SUPPORTED_TEXTURES.any? { |ext| extension.upcase[1..] == ext }
      content = io.gets_to_end
      image = Raylib.load_image_from_memory(extension, content, size)
      texture = Raylib.load_texture_from_image(image)
      raise "Texture invalid" unless Raylib.texture_ready?(texture)
      add_texture Texture.new(path, texture)
      true
    else
      false
    end
  end

  def self.add_texture(texture : Texture)
    emit Asset::Changed, texture if @@textures[texture.name]?
    @@textures[texture.name] = texture
  end

  def self.get_texture(name)
    @@textures[name]
  end

  def self.get_texture?(name)
    @@textures[name]?
  end

  def self.get_rtexture(name)
    @@textures[name].rtexture
  end

  def self.get_rtexture?(name)
    @@textures[name]?.try(&.rtexture)
  end

  on(Unload) do
    @@fonts.values.each do |f|
      Raylib.unload_font(f.rfont)
      emit Asset::Destroyed, f
    end
    @@fonts.clear
  end
end
