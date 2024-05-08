class Crixel::State
  getter members = [] of Crixel::Machine

  property persist_update = false
  property persist_draw = false


  event DestroyedState, state : self

  def update
  end

  def draw
  end
end