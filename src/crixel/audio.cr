require "raylib-cr/audio"

struct RAudio::Sound
  include Crixel::Asset
end

module Crixel::Assets
  SUPPORTED_SOUNDS = %w[WAV OGG MP3 FLAC XM MOD QOA]
  @@sounds = {} of String => RAudio::Sound

  add_consumer do |path, io, size|
    extension = Path.new(path).extension.downcase
    if SUPPORTED_SOUNDS.any? { |ext| extension.upcase[1..] == ext }
      content = io.gets_to_end
      wave = RAudio.load_wave_from_memory(extension, content, size)
      sound = RAudio.load_sound_from_wave(wave)
      raise "Sound invalid" unless RAudio.sound_ready?(sound)
      @@sounds[path] = sound
      true
    else
      false
    end
  end

  def self.get_sound(name)
    @@sounds[name]
  end

  on(PreSetup) do
    puts "Audio device turning on!"
    RAudio.init_audio_device
    last = Time.local
    until RAudio.audio_device_ready? || (Time.local - last).seconds < 20
    end

    raise "Audio error" unless RAudio.audio_device_ready?
    puts "Audio device on!"
  end

  on(Unload) do
    @@sounds.values.each do |s|
      RAudio.unload_sound(s)
      emit Asset::Destroyed, s
    end
    @@sounds.clear

    RAudio.close_audio_device
  end
end
