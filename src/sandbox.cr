# require "./crixel"

# class PlayState < Crixel::State
# end

# Crixel.run(400, 300, PlayState.new)

# Crixel.main_state.destroy

module A::B
  macro test
    {% puts @caller.first.receiver %}
  end
end

A::B.test