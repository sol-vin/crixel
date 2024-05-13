class Crixel::Basic
  include IUpdate
  include IDraw

  getter id : UInt32 = Crixel.get_id

  event Added, object : self

  event Destroyed, object : self

  getter? destroyed = false

  def destroy
    unless @destroyed
      @destroyed = true
      emit Destroyed, self
    end
  end
end
