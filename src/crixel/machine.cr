class Crixel::Machine
  getter id : Int32 = 0

  getter parent : State

  property? active : Bool = true
  property? visible : Bool = true

  event Added, machine : self
  event Destroyed, machine : self

  def initialize(@parent : State)
  end

  def destroy
    emit Destroyed, self
  end
  
  def update
  end

  def draw
  end
end