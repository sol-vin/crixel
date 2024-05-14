class Crixel::State
  # Hold information about if an object should be added or destroyed
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

  # The order objects should be updated
  getter update_order = [] of Basic
  # The order objects should be drawn
  getter draw_order = [] of Basic

  # Holds the list of actions that need to happen mid-draw.
  @action_queue = [] of QueuedAction

  # Should this state persistently update, even when it is not the main state?
  property persist_update = false

  # Should this state persistently draw, even when it is not the main state?
  property persist_draw = false

  # Is this state currently updating?
  getter? updating = false
  # Is this state currently drawing?
  getter? drawing = false

  # The main camera for this state.
  getter camera : ICamera = Camera.new

  event Destroyed, state : self
  event Changed, state : self
  event PreSetup, state : self
  event Setup, state : self
  event PostSetup, state : self
  event PreUpdate, state : self, total_time : Time::Span, elapsed_time : Time::Span
  event PostUpdate, state : self, total_time : Time::Span, elapsed_time : Time::Span
  event PreDraw, state : self, total_time : Time::Span, elapsed_time : Time::Span
  event PostDraw, state : self, total_time : Time::Span, elapsed_time : Time::Span

  def initialize
  end

  # View a camera on this state
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

  # Adds an object to this state. If the object is added mid-update/mid-draw add it to the action queue instead.
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

  # Removes an object from this state. If the object is removed mid-update/mid-draw add it to the action queue instead.
  def remove(object : Basic)
    if updating? || drawing?
      @action_queue << QueuedAction.new(QueuedAction::Type::Destroy, object)
    else
      _remove(object)
    end
  end

  # Run when the state becomes the main state for the first time (pushed via `Crixel.push_state`).
  def setup
    emit PreSetup, self
    emit Setup, self
    emit PostSetup, self
  end

  # Runs the action queue orders. Will add or delete objects from this state.
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

  def update(total_time : Time::Span, elapsed_time : Time::Span)
    _run_action_queue(dirty: true)
    @updating = true

    emit PreUpdate, self, total_time, elapsed_time
    @update_order.each do |child|
      child.update(total_time, elapsed_time) if child.active?
    end
    emit PostUpdate, self, total_time, elapsed_time

    @updating = false
    _run_action_queue()
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
    @draw_order.sort! { |a, b| a.draw_layer <=> b.draw_layer }
    @drawing = true
    Crixel.start_2d_mode(@camera)
    Raylib.clear_background(@camera.bg_color.to_raylib)

    emit PreDraw, self, total_time, elapsed_time
    @draw_order.each do |child|
      if child.visible?
        child.draw(total_time, elapsed_time)
      end
    end
    emit PostDraw, self, total_time, elapsed_time
    Crixel.stop_2d_mode
    @drawing = false
    _run_action_queue()
  end

  def destroy
    @update_order.each(&.destroy)
    @draw_order.each(&.destroy)
    emit Destroyed, self
  end
end
