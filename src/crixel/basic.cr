class Crixel::Basic
  getter id : UInt32 = Crixel.get_id

  property? active : Bool = true
  property update_layer = 0.0_f32
  property? visible : Bool = true
  property draw_layer = 0.0_f32

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

  def update
  end

  def draw
  end
end
