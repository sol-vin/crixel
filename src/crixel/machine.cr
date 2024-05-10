class Crixel::Machine
  getter id : Int32 = 0

  property? active : Bool = true
  property? visible : Bool = true

  event Added, machine : self
  event Destroyed, machine : self

  def initialize
  end

  def destroy
    emit Destroyed, self
  end
  
  def update
  end

  def draw
  end
end