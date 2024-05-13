class Crixel::State
  struct QueuedAction
    enum Type
      Add
      Destroy
    end

    getter type : Type
    getter item : Basic

    def initialize(@type, @item)
    end
  end

  getter update_order = [] of Basic
  getter draw_order = [] of Basic

  @action_queue = [] of QueuedAction

  property persist_update = false
  property persist_draw = false

  getter? updating = false
  getter? drawing = false

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

  def view(camera : ICamera)
    @camera = camera
  end

  private def _add(object : Basic)
    @update_order << object
    @draw_order << object
  end

  private def _remove(object : Basic)
    @update_order.delete object
    @draw_order.delete object

    # Reset the camera if this was one we were viewing.
    if camera == object
      view(Camera.new)
    end
  end

  def add(object : Basic)
    object.on_destroyed do
      remove(object)
    end

    if updating? || drawing?
      @action_queue << QueuedAction.new(QueuedAction::Type::Add, object)
    else
      _add(object)
    end

    emit Basic::Added, object
  end

  def remove(object : Basic)
        if updating? || drawing?
      @action_queue << QueuedAction.new(QueuedAction::Type::Destroy, object)
    else
      _remove(object)
    end
  end

  def setup
    emit PreSetup, self
    emit Setup, self
    emit PostSetup, self
  end

  private def _run_action_queue(dirty = false)
    @action_queue.each do |action|
      if action.type == QueuedAction::Type::Add
        @update_order << action.item
        @draw_order << action.item

        dirty = true
      elsif action.type == QueuedAction::Type::Destroy
        @update_order.delete(action.item)
        @draw_order.delete(action.item)
      end
    end
    
    if dirty
      @update_order.sort! { |a, b| a.update_layer <=> b.update_layer } 
      @draw_order.sort! { |a, b| a.draw_layer <=> b.draw_layer }
    end
  end

  def update
    Input::Manager.update(self)
    _run_action_queue(dirty: true)
    @updating = true
    
    emit PreUpdate, self
    @update_order.each do |child|
      child.update if child.active?
    end
    emit PostUpdate, self

    @updating = false
    _run_action_queue()
  end

  def draw
    @draw_order.sort! { |a, b| a.draw_layer <=> b.draw_layer }
    @drawing = true
    Raylib.begin_mode_2d(camera.to_rcamera)
    Raylib.clear_background(camera.bg_color.to_raylib)
    emit PreDraw, self
    @draw_order.each do |child|
      if child.visible?
        child.draw
      end
    end
    emit PostDraw, self

    Raylib.end_mode_2d
    @drawing = false
    _run_action_queue()
  end

  def destroy
    @update_order.each(&.destroy)
    @draw_order.each(&.destroy)
    emit Destroyed, self
  end
end
