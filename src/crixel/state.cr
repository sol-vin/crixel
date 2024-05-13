class Crixel::State
  getter update_order = [] of Basic
  getter draw_order = [] of Basic
  getter? children_added = false

  property persist_update = false
  property persist_draw = false

  getter camera : ICamera = Camera.new

  event Destroyed, state : self

  event Changed, state : self

  event PreSetup, state : self

  event Setup, state : self

  event PostSetup, state : self

  event PreUpdate, state : self

  event PostUpdate, state : self

  event PreDraw, state : self

  event PostDraw, state : self

  def initialize
  end

  def add(object : Basic)
    object.on_destroyed do
      @update_order.delete(object)
      @draw_order.delete(object)
    end

    @children_added = true
    @update_order << object
    @draw_order << object
    emit Basic::Added, object
  end

  def setup
    emit PreSetup, self
    emit Setup, self
    emit PostSetup, self
  end

  def update
    Input::Manager.update
    @update_order.sort! { |a, b| a.update_layer <=> b.update_layer }
    emit PreUpdate, self
    @update_order.dup.each do |child|
      child.update if child.active?
    end
    emit PostUpdate, self
  end

  def draw
    @draw_order.sort! { |a, b| a.draw_layer <=> b.draw_layer }
    Raylib.begin_mode_2d(camera.to_raylib)
    Raylib.clear_background(camera.bg_color.to_raylib)
    emit PreDraw, self
    @draw_order.dup.each do |child|
      if child.visible?
        child.draw
      end
    end
    emit PostDraw, self

    Raylib.end_mode_2d

    @children_added = false
  end

  def destroy
    @update_order.each(&.destroy)
    @draw_order.each(&.destroy)
    emit Destroyed, self
  end
end
