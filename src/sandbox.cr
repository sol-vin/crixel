require "./crixel"
require "./crixel/audio"
require "./crixel/input"
require "./crixel/text"
require "./crixel/graphics"

require "./crixel/default_rsrc"

Crixel::Assets::BakedFS.bake(path: "rsrc")

class PlayState < Crixel::State
  @text : Crixel::Text = Crixel::Text.new(text: "Hello World!", text_size: 50)

  def initialize
    super

    # Setup this state
    on_setup do
      add(@text)

      key = inputs.get_key(Crixel::Key::Code::W)
 
      key.on_down(name: "w_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @text.origin = @text.origin + Crixel::Vector2.unit_y * -elapsed_time.total_milliseconds * 0.1
        else
          @text.y -= elapsed_time.total_milliseconds * 0.1
        end
      end

      key = inputs.get_key(Crixel::Key::Code::S)

      key.on_down(name: "s_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @text.origin = @text.origin + Crixel::Vector2.unit_y * elapsed_time.total_milliseconds * 0.1
        else
          @text.y += elapsed_time.total_milliseconds * 0.1
        end
      end

      key = inputs.get_key(Crixel::Key::Code::A)

      key.on_down(name: "a_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @text.origin = @text.origin + Crixel::Vector2.unit_x * -elapsed_time.total_milliseconds * 0.1
        else
          @text.x -= elapsed_time.total_milliseconds * 0.1
        end
      end

      key = inputs.get_key(Crixel::Key::Code::D)

      key.on_down(name: "d_down") do |total_time, elapsed_time|
        if inputs.get_key(Crixel::Key::Code::LeftShift).down?
          @text.origin = @text.origin + Crixel::Vector2.unit_x * elapsed_time.total_milliseconds * 0.1
        else
          @text.x += elapsed_time.total_milliseconds * 0.1
        end
      end

      key = inputs.get_key(Crixel::Key::Code::Q)

      key.on_down(name: "q_down") do |total_time, elapsed_time|
        @text.rotation -= elapsed_time.total_milliseconds * 0.01
      end

      key = inputs.get_key(Crixel::Key::Code::E)

      key.on_down(name: "e_down") do |total_time, elapsed_time|
        @text.rotation += elapsed_time.total_milliseconds * 0.01
      end

      key = inputs.get_key(Crixel::Key::Code::Up)

      key.on_down(name: "up_down") do |total_time, elapsed_time|
        @text.text_size += elapsed_time.total_milliseconds * 0.01
      end

      key = inputs.get_key(Crixel::Key::Code::Down)

      key.on_down(name: "down_down") do |total_time, elapsed_time|
        @text.text_size -= elapsed_time.total_milliseconds * 0.01
      end
    end

    # Do stuff before objects are updated
    on_pre_update do |total_time, elapsed_time|
    end

    # Do stuff after the objects are updated
    on_post_update do |total_time, elapsed_time|
    end

    # Draw stuff below this state (in the camera)
    on_pre_draw do |total_time, elapsed_time|
    end

    # Draw stuff above this state (in the camera)
    on_post_draw do |total_time, elapsed_time|
    end

    # Draw stuff in the HUD (not in the camera)
    on_draw_hud do |total_time, elapsed_time|
      Raylib.draw_fps(0, 0)
    end
  end
end

Crixel.play(400, 300) { PlayState.new }
