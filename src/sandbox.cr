require "./crixel"
require "./crixel/audio"
require "./crixel/input"
require "./crixel/text"
require "./crixel/graphics"

require "./crixel/default_rsrc"

Crixel::Assets::BakedFS.bake(path: "rsrc")


class PlayState < Crixel::State
  @total_time_text = Crixel::Text.new(text_size: 20, tint: Crixel::Color::RGBA::CYAN)

  @startup : Crixel::Sound = Crixel::Sound.new("default_rsrc/flixel.mp3")

  @character : Crixel::Character = Crixel::Character.new

  def initialize
    super

    on_setup do
      @camera.camera_bg_color = Crixel::Color::RGBA::BLACK
      @camera.camera_offset = Crixel::Vector2.new(x: 200, y: 150)

      @startup.play

      anim = Crixel::Animation.from_spritesheet("rsrc/mysheet.png", 5, 1)
      anim.looping = true
      @character.add_animation(:test, anim)
      @character.play(:test)

      add(@character)
      view(@character)
    end

    on_pre_update do |total_time, elapsed_time|
      @total_time_text.text = total_time.total_seconds.to_s
    end

    on_draw_hud do |total_time, elapsed_time|
      @total_time_text.draw(total_time, elapsed_time)
    end

    on_post_draw do |total_time, elapsed_time|
    end
  end
end

Crixel.start_window(400, 300) # This must be done here
Crixel.run(PlayState.new)

