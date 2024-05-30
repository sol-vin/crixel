require "crixel"
require "crixel/text"
require "crixel/default_rsrc"

Crixel.start_window(400, 300)
# Anything Crixel related should happen in between `start_window` and `run`
state = Crixel::State.new
state.on_draw_hud do
  Crixel::Text.draw("Hello World!", text_height: 40)
end
Crixel.run(state)
