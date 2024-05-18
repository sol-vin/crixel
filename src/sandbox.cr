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
      @camera.origin = Crixel::Vector2.new(x: 200, y: 150)

      @startup.play

      anim = Crixel::Animation.from_spritesheet("rsrc/mysheet.png", 5, 1)
      anim.looping = true
      @character.add_animation(:test, anim)
      @character.play(:test)

      add(@character)
      # view(@camera)

      @camera.x = @character.x
      @camera.y = @character.y
      # @camera.camera_zoom = 0.5

      # view(@character)

      key = inputs.get_key(Crixel::Key::Code::W)

      key.on_down(name: "w_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @character.origin = @character.origin + Crixel::Vector2.unit_y * -0.1
        else
          @character.y -= 0.1
        end
      end

      key = inputs.get_key(Crixel::Key::Code::S)

      key.on_down(name: "s_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @character.origin = @character.origin + Crixel::Vector2.unit_y * 0.1
        else
          @character.y += 0.1
        end
      end

      key = inputs.get_key(Crixel::Key::Code::A)

      key.on_down(name: "a_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @character.origin = @character.origin + Crixel::Vector2.unit_x * -0.1
        else
          @character.x -= 0.1
        end
      end

      key = inputs.get_key(Crixel::Key::Code::D)

      key.on_down(name: "d_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @character.origin = @character.origin + Crixel::Vector2.unit_x * 0.1
        else
          @character.x += 0.1
        end
      end

      key = inputs.get_key(Crixel::Key::Code::Up)

      key.on_down(name: "up_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @character.current_animation.frames.map! {|f| f.origin = f.origin + Crixel::Vector2.unit_y * -0.1; f}
        else
          @character.current_animation.frames.map! {|f| f.y -= 0.1; f }
        end
      end

      key = inputs.get_key(Crixel::Key::Code::Down)

      key.on_down(name: "down_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @character.current_animation.frames.map! {|f| f.origin = f.origin + Crixel::Vector2.unit_y * 0.1; f}
        else
          @character.current_animation.frames.map! {|f| f.y += 0.1; f }
        end
      end

      key = inputs.get_key(Crixel::Key::Code::Left)

      key.on_down(name: "left_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @character.current_animation.frames.map! {|f| f.origin = f.origin + Crixel::Vector2.unit_x * -0.1; f}
        else
          @character.current_animation.frames.map! {|f| f.x -= 0.1; f }
        end
      end

      key = inputs.get_key(Crixel::Key::Code::Right)

      key.on_down(name: "right_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @character.current_animation.frames.map! {|f| f.origin = f.origin + Crixel::Vector2.unit_x * 0.1; f}
        else
          @character.current_animation.frames.map! {|f| f.x += 0.1; f }
        end
      end

      key = inputs.get_key(Crixel::Key::Code::Q)

      key.on_down(name: "q_down") do |total_time, elapsed_time|
        @character.rotation -= 0.001
      end

      key = inputs.get_key(Crixel::Key::Code::E)

      key.on_down(name: "e_down") do |total_time, elapsed_time|
        @character.rotation += 0.001
      end

      key = inputs.get_key(Crixel::Key::Code::Comma)

      key.on_down(name: "comma_down") do |total_time, elapsed_time|
        @character.current_animation.frames.map! {|f| f.rotation -= 0.01; f }
      end

      key = inputs.get_key(Crixel::Key::Code::Period)

      key.on_down(name: "period_down") do |total_time, elapsed_time|
        @character.current_animation.frames.map! {|f| f.rotation += 0.01; f }
      end
    end

    on_pre_update do |total_time, elapsed_time|
      @total_time_text.text = total_time.total_seconds.to_s
    end

    on_draw_hud do |total_time, elapsed_time|
      @total_time_text.draw(total_time, elapsed_time)
    end

    on_post_draw do |total_time, elapsed_time|
      @character.position.draw(tint: Crixel::Color::RGBA::RED)
      (@character.position + @character.origin).draw(tint: Crixel::Color::RGBA::MAGENTA)
      @character.current_frame_rect.draw(tint: Crixel::Color::RGBA::BLUE)
      (@character.current_animation.current_frame.origin + @character.position+ @character.current_animation.current_frame.position).draw(tint: Crixel::Color::RGBA::GREEN)
    end
  end
end

Crixel.start_window(400, 300) # This must be done here
Crixel.run(PlayState.new)

