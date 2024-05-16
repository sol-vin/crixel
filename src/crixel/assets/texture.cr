class Crixel::Assets::Texture < Crixel::Asset
  getter name : String
  property rtexture : Raylib::Texture2D

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
    if @@textures[texture.name]?
      emit Asset::Changed, @@textures[texture.name], texture
      @@textures[texture.name].rtexture = texture.rtexture
    else
      @@textures[texture.name] = texture
    end
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

  def self.remove_texture(name, unload = true)
    if t = @@textures[name]?
      @@textures.delete(name)
      if unload
        Raylib.unload_texture(t.rtexture)
        emit Asset::Destroyed, t
      end
    end
  end

  on(Unload) do
    @@textures.values.each do |t|
      Raylib.unload_texture(t.rtexture)
      emit Asset::Destroyed, t
    end
    @@textures.clear
  end
end
