require "minievents"
MiniEvents.install(::Crixel::Event)

require "raylib-cr"
require "raylib-cr/rlgl"

require "./crixel/modules/**"
require "./crixel/input/modules/**"
require "./crixel/input/**"

require "./crixel/camera"

require "./crixel/state"
require "./crixel/basic"

require "./crixel/sprite"

require "./crixel/assets/**"

module Crixel
  VERSION       = "0.0.1"
  VERSION_STATE = "alpha"

  class_getter width : Int32 = 0
  class_getter height : Int32 = 0
  class_getter title : String = ""
  class_getter? running = false

  class_getter last_id : UInt32 = 0

  @@states = [] of State

  event State::Destroyed, state : State
  event State::Changed, state : State
  event Game::Open
  event Game::Close

  Crixel::Assets::BakedFS.bake(path: "default_rsrc")

  def self.run(@@width, @@height, state = State.new, @@title = "Crixel")
    if !@@running
      Raylib.init_window(@@width, @@height, title)

      Raylib.poll_input_events
      Keys.setup
      Gamepad::Buttons.setup
      Gamepad::Triggers.setup
      Mouse::Buttons.setup

      on(State::Destroyed) do |state|
        puts "State destroyed #{state.class}"
        if state == main_state
          old = @@states.pop
          old.destroy
        else
          @@states.delete(state)
        end
      end

      @@running = true

      Assets.setup

      push state

      emit Game::Open

      until should_close?
        Input::Manager.update
        update
        draw
      end

      close
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
        state.update
      else
        state.update if state.persist_update
      end
    end
  end

  def self.draw
    @@states.reverse_each.with_index do |state, index|
      # Check if we are the top state
      if index == 0
        state.draw
      else
        state.draw if state.persist_draw
      end
    end
    Raylib.end_drawing
  end

  def self.should_close?
    Raylib.close_window?
  end

  def self.close
    @@running = false
    emit Game::Close
    Raylib.close_window
  end
end
