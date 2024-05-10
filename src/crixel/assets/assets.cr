module Crixel::Assets
  SUPPORTED_TEXTURES = %w[PNG BMP TGA JPG GIF QOI PSD DDS HDR KTX ASTC PKM PVR]
  SUPPORTED_FONTS = %w[TTF OTF]
  SUPPORTED_SOUNDS = %w[WAV OGG MP3 FLAC XM MOD QOA]

  @@textures = {} of String => Raylib::Texture2D

  event Setup

  def self.setup
    BakedFS.files.each do |baked_file|
      if SUPPORTED_TEXTURES.any? {|ext| Path.new(baked_file.path).extension.upcase[1..] == ext}
        content = baked_file.gets_to_end
        image = Raylib.load_image_from_memory(".png", content, baked_file.size)
        texture = Raylib.load_texture_from_image(image)
        @@textures[baked_file.path] = texture
      end
    end

    emit Setup
  end

  def self.get_texture(name)
    @@textures[name]
  end
end