class Crixel::GameObject
  getter id : Int32 = 0

  property? active : Bool = true
  property? visible : Bool = true

  event Added, object : self
  event Destroyed, object : self

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
