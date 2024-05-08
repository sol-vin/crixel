class Crixel::State
  getter members = [] of Crixel::Machine

  event DestroyedState, state : self
end