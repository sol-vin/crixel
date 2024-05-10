module Crixel::Assets
  SUPPORTED_TEXTURES = %w[PNG BMP TGA JPG GIF QOI PSD DDS HDR KTX ASTC PKM PVR]
  SUPPORTED_FONTS = %w[TTF OTF]
  SUPPORTED_SOUNDS = %w[WAV OGG MP3 FLAC XM MOD QOA]

  @@textures = {} of String => Raylib::Texture2D

  event Setup

  def self.setup
    emit Setup
  end

  def self.load(path : String, io : IO, size : Int32)
    raise "Cannot load before window is initialized: Try running asset loading methods from an `on Crixel::Assets::Setup`" unless Crixel.running?
    if SUPPORTED_TEXTURES.any? {|ext| Path.new(path).extension.upcase[1..] == ext}
      content = io.gets_to_end
      image = Raylib.load_image_from_memory(".png", content, size)
      texture = Raylib.load_texture_from_image(image)
      @@textures[path] = texture
    end
  end

  def self.load_from_path(filename : String)
    File.open(filename) do |file|
      load(filename, file, file.size.to_i32)
    end
  end

  def self.get_texture(name)
    @@textures[name]
  end
end