class Crixel::State
  getter children = [] of Machine
  
  property persist_update = false
  property persist_draw = false
  
  event Changed, state : self
  event Destroyed, state : self

  getter camera : Camera = Camera.new

  def add(machine : Machine)
    machine.on_destroyed do |machine|
      @children.delete(machine)
    end

    @children << machine

    emit Machine::Added, machine
  end

  def update
    @children.each do |child|
      child.update if child.active?
    end
  end
  
  def draw
    Raylib.begin_mode_2d(camera.to_raylib)
    Raylib.clear_background(camera.bg_color)

    @children.each do |child|
      child.draw if child.draw?
    end
    Raylib.end_mode_2d
  end

  def destroy
    emit Destroyed, self
  end
end