require "./crixel"

class PlayState < Crixel::State
end

Crixel.run(400, 200, PlayState.new)

Crixel.main_state.destroy