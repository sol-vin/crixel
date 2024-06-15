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
  # Should this state persistently update, even when it is not the main state?
  property persist_update = false

  # Should this state persistently draw, even when it is not the main state?
  property persist_draw = false

  # Is this state currently updating?
  getter? updating = false
  # Is this state currently drawing?
  getter? drawing = false

  single_event Destroyed, state : self
  single_event Changed, state : self
  single_event PreSetup, state : self
  single_event Setup, state : self
  single_event PostSetup, state : self
  single_event PreUpdate, state : self, total_time : Time::Span, elapsed_time : Time::Span
  single_event PostUpdate, state : self, total_time : Time::Span, elapsed_time : Time::Span
  single_event PreDraw, state : self, total_time : Time::Span, elapsed_time : Time::Span
  single_event DrawHUD, state : self, total_time : Time::Span, elapsed_time : Time::Span
  single_event PostDraw, state : self, total_time : Time::Span, elapsed_time : Time::Span

  private def add(object : Basic)
    object.on_destroyed(once: true) do
      remove(object)
    end

    @update_order << object
    @draw_order << object
    emit Basic::Added, object, self
  end

  private def remove(object : Basic)
    @update_order.delete object
    @draw_order.delete object

    # Reset the camera if this was one we were viewing.
    if Crixel.camera == object
      Crixel.view(Camera.new)
    end
  end

  # Run when the state becomes the main state for the first time (pushed via `Crixel.push_state`).
  def setup
    emit PreSetup, self
    emit Setup, self
    emit PostSetup, self
  end

  def update(total_time : Time::Span, elapsed_time : Time::Span)
    @updating = true

    emit PreUpdate, self, total_time, elapsed_time
    index = 0
    original_size = @update_order.size
    until index == @update_order.size
      child = @update_order[index]
      child.update(total_time, elapsed_time) if child.active?
      index += 1 if original_size == @update_order.size
    end
    emit PostUpdate, self, total_time, elapsed_time

    @updating = false
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
    @drawing = true

    emit PreDraw, self, total_time, elapsed_time
    index = 0
    original_size = @draw_order.size
    until index == @draw_order.size
      child = @draw_order[index]
      child.draw(total_time, elapsed_time) if child.visible?
      index += 1 if original_size == @draw_order.size
    end
    emit PostDraw, self, total_time, elapsed_time

    Raylib.end_mode_2d
    draw_hud(total_time, elapsed_time)
    Raylib.begin_mode_2d(Crixel.camera.to_rcamera)
    @drawing = false
  end

  def draw_hud(total_time : Time::Span, elapsed_time : Time::Span)
    emit DrawHUD, self, total_time, elapsed_time
  end

  def destroy
    @update_order.each(&.destroy)
    @draw_order.each(&.destroy)
    emit Destroyed, self
  end
end
