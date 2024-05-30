class Crixel::Basic
  include Updatable
  include Drawable

  getter id : UInt32

  event Added, object : self, parent : State
  event Destroyed, object : self

  getter? destroyed = false

  def initialize
    @id = Crixel.get_id
  end

  def destroy
    unless @destroyed
      @destroyed = true
      emit Destroyed, self
      clear_added
      clear_destroyed
    end
  end

  def equals?(other : self)
    self.id == other.id
  end

  def ==(other : self)
    self.id == other.id
  end

  def hash
    self.id
  end
end
