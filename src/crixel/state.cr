class Crixel::State
  getter update_order = [] of Basic
  getter draw_order = [] of Basic
  getter? children_added = false

  property persist_update = false
  property persist_draw = false

  getter camera : ICamera = Camera.new

  event Destroyed, state : self
  attach_self Destroyed

  event Changed, state : self
  attach_self Changed

  event Setup, state : self
  attach_self Setup

  event PreUpdate, state : self
  attach_self PreUpdate

  event PostUpdate, state : self
  attach_self PostUpdate

  event PreDraw, state : self
  attach_self PreDraw

  event PostDraw, state : self
  attach_self PostDraw

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
    object.emit_added
  end

  def setup
    emit_setup
  end

  def sort_update
    if children_added?
      @update_order.sort! { |a, b| a.update_layer <=> b.update_layer }
    end
  end

  def sort_draw
    if children_added?
      @draw_order.sort! { |a, b| a.draw_order <=> b.draw_order }
    end
  end

  def pre_update
    emit_pre_update
  end

  def update
    Input::Manager.update
    pre_update
    @update_order.each do |child|
      child.update if child.active?
    end
    post_update
  end

  def post_update
    emit_post_update
  end

  def pre_draw
    emit_pre_draw
  end

  def draw
    @draw_order.sort! { |a, b| a.draw_layer <=> b.draw_layer }
    Raylib.begin_mode_2d(camera.to_raylib)
    Raylib.clear_background(camera.bg_color.to_raylib)
    pre_draw
    @draw_order.each do |child|
      if child.visible?
        child.draw
      end
    end
    post_draw

    Raylib.end_mode_2d

    @children_added = false
  end

  def post_draw
    emit_post_draw
  end

  def destroy
    @update_order.each(&.destroy)
    @draw_order.each(&.destroy)
    emit Destroyed, self
  end
end
