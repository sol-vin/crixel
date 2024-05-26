require "./crixel"
require "./crixel/audio"
require "./crixel/input"
require "./crixel/text"
require "./crixel/graphics"

require "./crixel/default_rsrc"

Crixel::Assets::BakedFS.bake(path: "rsrc")

class PlayState < Crixel::State
  def initialize
    super

    # Setup this state
    on_setup do
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
    end
  end
end

Crixel.start_window(400, 300) # This must be done here
Crixel.run(PlayState.new)
