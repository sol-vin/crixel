class Crixel::Basic
  include IUpdate
  include IDraw
  
  getter id : UInt32 = Crixel.get_id

  event Added, object : self
  attach_self Added

  event Destroyed, object : self
  attach_self Destroyed

  getter? destroyed = false

  def destroy
    unless @destroyed
      @destroyed = true
      emit_destroyed
    end
  end
end
