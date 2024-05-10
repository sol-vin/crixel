class Crixel::State
  getter children = [] of Basic

  property persist_update = false
  property persist_draw = false

  getter camera : ICamera = Camera.new

  event Setup, state : self
  
  attach Setup

  def add(object : Basic)
    object.on_destroyed do |object|
      @children.delete(object)
    end

    @children << object

    emit Basic::Added, object
  end

  def setup
    emit_setup self
  end

  def pre_update
  end

  def update
    pre_update
    @children.each do |child|
      child.update if child.active?
    end
    post_update
  end

  def post_update
  end

  def pre_draw
  end

  def draw
    Raylib.begin_mode_2d(camera.to_raylib)
    Raylib.clear_background(camera.bg_color)
    pre_draw
    @children.each do |child|
      child.draw if child.visible?
    end
    post_draw
    Raylib.end_mode_2d
  end

  def post_draw
  end

  def destroy
    children.each(&.destroy)
    emit Destroyed, self
  end
end
