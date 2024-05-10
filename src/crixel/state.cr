class Crixel::State
  getter children = [] of GameObject

  property persist_update = false
  property persist_draw = false

  getter camera : ICamera = Camera.new

  event Setup, state : self

  def add(object : GameObject)
    object.on_destroyed do |object|
      @children.delete(object)
    end

    @children << object

    emit GameObject::Added, object
  end

  def setup
    emit Setup, self
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
      child.draw if child.visible?
    end
    Raylib.end_mode_2d
  end

  def destroy
    emit Destroyed, self
  end
end
