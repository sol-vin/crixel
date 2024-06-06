require "crixel"
require "crixel/text"
require "crixel/default_rsrc"

class PlayState < Crixel::State
  DISTANCE = 50
  @text : Crixel::Text = Crixel::Text.new(text: "Hello World", text_size: 40)

  def initialize
    # Assign events here such as "on_setup", "on_pre_draw", etc

    on_setup do
      @text

      add(@text) # Adds out text element to the scene.
    end

    on_pre_update do |total_time, ellapsed_time|
      @text.origin = Crixel::Vector2.new(@text.width/2, @text.height/2)
      @text.x = (Crixel.width/2 + Math.sin(total_time.total_seconds) * DISTANCE).to_f32
      @text.y = (Crixel.height/2 + Math.cos(total_time.total_seconds) * DISTANCE).to_f32
    end
  end
end

Crixel.start_window(400, 300)
Crixel.run(PlayState.new)
