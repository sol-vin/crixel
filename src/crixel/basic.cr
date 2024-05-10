class Crixel::Basic
  getter id : UInt32 = Crixel.get_id

  property? active : Bool = true
  property? visible : Bool = true

  event Added, object : self
  attach Added

  event Destroyed, object : self
  attach Destroyed


  def destroy
    emit Destroyed, self
  end

  def update
  end

  def draw
  end
end
