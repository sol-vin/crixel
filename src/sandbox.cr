require "./crixel"

class PlayState < Crixel::State
end

Crixel.run(400, 300, PlayState.new)