module Crixel::Assets
  SUPPORTED_TEXTURES = %w[PNG BMP TGA JPG GIF QOI PSD DDS HDR KTX ASTC PKM PVR]
  SUPPORTED_FONTS = %w[TTF OTF]
  SUPPORTED_SOUNDS = %w[WAV OGG MP3 FLAC XM MOD QOA]

  @@textures = {} of String => Raylib::Texture2D

  event Setup

  def self.setup
    emit Setup
  end

  def self.get_texture(name)
    @@textures[name]
  end
end