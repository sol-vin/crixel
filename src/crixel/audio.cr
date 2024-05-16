require "./assets/sound"

class Crixel::Sound
  @sound_alias : RAudio::Sound

  def initialize(sound_name : String)
    sound = Assets.get_sound(sound_name)
    @sound_alias = RAudio.load_sound_alias(sound.rsound)

    sound.on_changed do |to|
      RAudio.unload_sound_alias(@sound_alias) if RAudio.sound_ready? @sound_alias
      @sound_alias = RAudio.load_sound_alias(to.as(Assets::Sound).rsound)
    end

    sound.on_destroyed do
      RAudio.unload_sound_alias(@sound_alias) if RAudio.sound_ready? @sound_alias
      @sound_alias = RAudio::Sound.new
    end
  end

  def play
    if RAudio.sound_ready?(@sound_alias) && !playing?
      RAudio.play_sound(@sound_alias)
    elsif RAudio.sound_ready?(@sound_alias) && playing?
    else
      raise "Cannot play sound that isnt loaded :("
    end
  end

  def replay
    if RAudio.sound_ready?(@sound_alias)
      RAudio.play_sound(@sound_alias)
    else
      raise "Cannot play sound that isnt loaded :("
    end
  end

  def stop
    if RAudio.sound_ready?(@sound_alias)
      RAudio.stop_sound(@sound_alias)
    else
      raise "Cannot play sound that isnt loaded :("
    end
  end

  def pause
    if RAudio.sound_ready?(@sound_alias)
      RAudio.pause_sound(@sound_alias)
    else
      raise "Cannot play sound that isnt loaded :("
    end
  end

  def resume
    if RAudio.sound_ready?(@sound_alias)
      RAudio.resume_sound(@sound_alias)
    else
      raise "Cannot play sound that isnt loaded :("
    end
  end

  def playing?
    if RAudio.sound_ready?(@sound_alias)
      RAudio.sound_playing?(@sound_alias)
    else
      false
    end
  end

  def destroy
    RAudio.unload_sound_alias(@sound_alias)
  end

  getter volume : Float32 = 1.0_f32

  def volume=(vol : Float32)
    @volume = vol
    RAudio.set_sound_volume vol
  end

  getter pitch : Float32 = 1.0_f32

  def pitch=(pitch : Float32)
    @pitch = pitch
    RAudio.set_sound_pitch pitch
  end

  getter pan : Float32 = 1.0_f32

  def pan=(pan : Float32)
    @pan = pan
    RAudio.set_sound_pan pan
  end
end

#TODO: Raylib::Music
