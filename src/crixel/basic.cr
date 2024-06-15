class Crixel::Basic
  include Updatable
  include Drawable

  getter id : Crixel::ID

  single_event Added, object : self, parent : State
  single_event Destroyed, object : self

  getter? destroyed = false

  def initialize
    @id = Crixel.get_id
  end

  def destroy
    unless @destroyed
      @destroyed = true
      emit Destroyed, self
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
