require "minievents"
MiniEvents.install(::Crixel::Event)

require "raylib-cr"
require "raylib-cr/rlgl"

require "./crixel/data/**"
require "./crixel/timer"

require "./crixel/modules/**"
require "./crixel/input/modules/**"
require "./crixel/input/**"

require "./crixel/camera"

require "./crixel/state"
require "./crixel/basic"
require "./crixel/emitter"

require "./crixel/assets/assets"

module Crixel
  VERSION       = "0.0.1"
  VERSION_STATE = "alpha"

  alias ID = UInt32

  class_getter width : Int32 = 0
  class_getter height : Int32 = 0
  class_getter title : String = ""
  class_getter? running = false
  class_getter? started = false
  class_getter? closing = false

  class_getter last_id : UInt32 = 0

  @@states = [] of State

  class_getter running_state : State = State.new

  event Start
  event Started
  event Open
  event FrameProcessed, total_time : Time::Span, elapsed_time : Time::Span
  event Close
  event Closed

  class_getter camera : ICamera = Camera.new
  @@render_texture_stack = [] of Raylib::RenderTexture

  @@screen : Raylib::RenderTexture = Raylib::RenderTexture.new

  @@src : Raylib::Rectangle = Raylib::Rectangle.new
  @@dst : Raylib::Rectangle = Raylib::Rectangle.new

  def self.window_width
    Raylib.get_screen_width
  end

  def self.window_height
    Raylib.get_screen_height
  end

  def self.current_rt? : Raylib::RenderTexture?
    @@render_texture_stack[-1]?
  end

  def self.enabled_rt_mode?
    @@render_texture_stack.size > 0
  end

  def self.start_rt_mode(rt : Raylib::RenderTexture)
    if enabled_rt_mode?
      Raylib.end_texture_mode
    end

    @@render_texture_stack << rt

    Raylib.begin_texture_mode(rt)
  end

  def self.stop_rt_mode
    if @@render_texture_stack.pop?
      Raylib.end_texture_mode
      if rt = current_rt?
        Raylib.begin_texture_mode(rt)
      else
      end
    else
      raise "Crixel.stop_rt_mode called but no rt was on the stack...."
    end
  end

  def self.view(camera : ICamera)
    @@camera = camera
  end

  def self.play(width, height, title = "Crixel", &block : Proc(State))
    start_window(width, height)
    state = yield
    run(state, title)
  end

  def self.start_window(@@width, @@height)
    if !@@started
      Raylib.set_trace_log_level(Raylib::TraceLogLevel::Warning)
      @@started = true
      Raylib.init_window(@@width, @@height, title)
      Raylib.set_window_state(Raylib::ConfigFlags::WindowResizable)
      Raylib.set_target_fps(60)
      @@screen = Raylib.load_render_texture(@@width, @@height)
      recalculate_window
      emit Start
      emit Started
    end
  end

  class_getter total_time : Time::Span = Time::Span.new(nanoseconds: 0)
  class_getter elapsed_time : Time::Span = Time::Span.new(nanoseconds: 0)

  def self.recalculate_window
    @@src = Raylib::Rectangle.new(
      x: 0,
      y: 0,
      width: @@width,
      height: -@@height
    )

    window_width = Raylib.get_screen_width.to_f32
    window_height = Raylib.get_screen_height.to_f32

    @@dst = Raylib::Rectangle.new(
      x: 0,
      y: 0,
      width: 0,
      height: 0
    )

    window_ratio = window_width/window_height
    screen_ratio = @@width.to_f32/@@height.to_f32
    if window_ratio > screen_ratio
      # Window is more wide than the screen
      @@dst.height = window_height
      @@dst.width = window_height * screen_ratio

      @@dst.x = (window_width/2) - (@@dst.width/2)
    else
      # Window is more high than the screen
      @@dst.width = window_width
      @@dst.height = window_width/screen_ratio

      @@dst.y = (window_height/2) - (@@dst.height/2)
    end
  end

  def self.run(state = State.new, @@title = "Crixel")
    if @@started && !@@running
      @@running = true

      emit Open

      push state

      until should_close?
        @@elapsed_time = Time.measure do
          Raylib.begin_drawing
          Mouse.update
          start_rt_mode(@@screen)
          update(@@total_time, @@elapsed_time)
          Raylib.begin_mode_2d(@@camera.to_rcamera)
          Raylib.clear_background(@@camera.camera_bg_color.to_raylib)
          draw(@@total_time, @@elapsed_time)
          Raylib.end_mode_2d
          stop_rt_mode

          if current_rt?
            raise "RT Stack had entries after the frame was done.
                   stop_rt_mode needs to be called a number of times before this point"
          end

          if Raylib.window_resized?
            recalculate_window
          end
          Raylib.clear_background(Raylib::BLACK)
          Raylib.draw_texture_pro(@@screen.texture, @@src, @@dst, Raylib::Vector2.zero, 0, Raylib::WHITE)
          Raylib.end_drawing
        end

        @@total_time += elapsed_time
        emit FrameProcessed, @@total_time, @@elapsed_time
      end

      Assets.unload
      @@closing = true
      _close
    elsif !@@started
      raise "Use Crixel.start_window first"
    else
      raise "Crixel is already running!"
    end
  end

  def self.get_id : UInt32
    old = @@last_id
    @@last_id += 1
    old
  end

  def self.title=(title)
    @@title = title
    Raylib.set_window_title(title)
  end

  def self.push(state : State)
    @@running_state = state
    state.setup

    @@states.push state

    # If the state is deleted, pop if is the main_state, or delete it out of states
    state.on_destroyed do
      if state == main_state
        state = @@states.pop
      else
        @@states.delete(state)
      end
    end

    emit State::Changed, state
  end

  def self.pop
    state = @@states.pop
    state.destroy
    emit State::Changed, main_state
  end

  def self.main_state
    @@states.last
  end

  def self.update(total_time : Time::Span, elapsed_time : Time::Span)
    @@states.reverse_each.with_index do |state, index|
      # Check if we are the top state
      if index == 0
        @@running_state = state
        state.update(total_time, elapsed_time)
      else
        if state.persist_update
          @@running_state = state
          state.update(total_time, elapsed_time)
        end
      end
    end
  end

  def self.draw(total_time : Time::Span, elapsed_time : Time::Span)
    @@states.each.with_index do |state, index|
      # Check if we are the top state
      if index == @@states.size-1
        @@running_state = state
        state.draw(total_time, elapsed_time)
      else
        if state.persist_draw
          @@running_state = state
          state.draw(total_time, elapsed_time)
        end
      end
    end
  end

  def self.should_close?
    Raylib.close_window? || closing?
  end

  private def self._close
    @@running = false
    emit Close
    @@states.each(&.destroy)
    @@states.clear
    Raylib.unload_render_texture(@@screen)
    Raylib.close_window
    emit Closed
    @@started = false
  end

  def self.close
    @@closing = true
  end
end
