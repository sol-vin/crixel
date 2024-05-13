require "minievents"
MiniEvents.install(::Crixel::Event)

require "raylib-cr"
require "raylib-cr/rlgl"

require "./crixel/data/**"

require "./crixel/modules/**"
require "./crixel/input/modules/**"
require "./crixel/input/**"

require "./crixel/camera"
require "./crixel/timer"

require "./crixel/state"
require "./crixel/basic"

require "./crixel/sprite"
require "./crixel/text"
require "./crixel/render_target"

require "./crixel/assets/**"

module Crixel
  VERSION       = "0.0.1"
  VERSION_STATE = "alpha"

  class_getter width : Int32 = 0
  class_getter height : Int32 = 0
  class_getter title : String = ""
  class_getter? running = false
  class_getter? started = false

  class_getter last_id : UInt32 = 0

  @@states = [] of State

  class_getter running_state : State = State.new

  event Open
  event Close

  macro install_default_assets
    Crixel::Assets::BakedFS.bake(path: "default_rsrc")
  end

  def self.start_window(@@width, @@height)
    if !@@started
      @@started = true
      Raylib.init_window(@@width, @@height, title)
    end
  end

  def self.run(state = State.new, @@title = "Crixel")
    if @@started && !@@running
      @@running = true

      state.on_destroyed do
        puts "State destroyed #{state.class}"
        if state == main_state
          old = @@states.pop
          old.destroy
        else
          @@states.delete(state)
        end
      end

      Assets.setup

      push state

      emit Open

      until should_close?
        Raylib.begin_drawing
        Mouse.update
        update
        draw
        Raylib.end_drawing
      end

      Assets.unload
      close
    elsif !@@started
      @@started = true
      run(state, @@title)
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

  def self.update
    @@states.reverse_each.with_index do |state, index|
      # Check if we are the top state
      if index == 0
        @@running_state = state
        state.update
      else
        if state.persist_update
          @@running_state = state
          state.update
        end
      end
    end
  end

  def self.draw
    @@states.reverse_each.with_index do |state, index|
      # Check if we are the top state
      if index == 0
        @@running_state = state
        state.draw
      else
        if state.persist_draw
          @@running_state = state
          state.draw
        end
      end
    end
  end

  def self.should_close?
    Raylib.close_window?
  end

  def self.close
    @@running = false
    emit Close
    Raylib.close_window
  end
end
