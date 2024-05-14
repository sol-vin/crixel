require "raylib-cr/audio"

class Crixel::Assets::Sound < Crixel::Asset
  getter name : String
  getter rsound : RAudio::Sound

  def initialize(@name, @rsound)
  end
end

module Crixel::Assets
  SUPPORTED_SOUNDS = %w[WAV OGG MP3 FLAC XM MOD QOA]
  @@sounds = {} of String => Sound

  add_consumer do |path, io, size|
    extension = Path.new(path).extension.downcase
    if SUPPORTED_SOUNDS.any? { |ext| extension.upcase[1..] == ext }
      content = io.gets_to_end
      wave = RAudio.load_wave_from_memory(extension, content, size)
      sound = RAudio.load_sound_from_wave(wave)
      raise "Sound invalid" unless RAudio.sound_ready?(sound)
      add_sound Sound.new(path, sound)
      true
    else
      false
    end
  end

  def self.add_sound(sound : Sound)
    emit Asset::Changed, sound if @@sounds[sound.name]?
    @@sounds[sound.name] = sound
  end

  def self.get_sound(name)
    @@sounds[name]
  end

  def self.get_sound?(name)
    @@sounds[name]?
  end

  def self.get_rsound(name)
    @@sounds[name].rsound
  end

  def self.get_rsound?(name)
    @@sounds[name]?.try(&.rsound)
  end

  on(PreSetup) do
    RAudio.init_audio_device
    last = Time.local
    until RAudio.audio_device_ready? || (Time.local - last).seconds < 20
    end

    raise "Audio error" unless RAudio.audio_device_ready?
  end

  on(Unload) do
    @@sounds.values.each do |s|
      RAudio.unload_sound(s.rsound)
      emit Asset::Destroyed, s
    end
    @@sounds.clear

    RAudio.close_audio_device
  end
end
