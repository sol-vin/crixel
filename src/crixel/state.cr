class Crixel::State
  getter members = [] of Crixel::Machine
  
  property persist_update = false
  property persist_draw = false
  
  event IsMain, state : self
  event Destroyed, state : self
  
  def update
    machines.each(&.update)
  end
  
  def draw
    machines.each(&.draw)
  end

  def destroy
    emit Destroyed, self
  end
end