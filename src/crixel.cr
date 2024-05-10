require "minievents"
MiniEvents.install(::Crixel::Event)

require "raylib-cr"

require "./crixel/icamera"
require "./crixel/camera"

require "./crixel/state"
require "./crixel/machine"

module Crixel
  VERSION = "0.0.1"
  VERSION_STATE = "alpha"

  class_getter width : Int32 = 0
  class_getter height : Int32 = 0
  class_getter title : String = ""
  class_getter? running = false

  @@states = [] of State

  event State::Destroyed, state : State
  event State::Changed, state : State
  event Game::Open
  event Game::Close

  def self.run(@@width, @@height, state = State.new, @@title = "Crixel")
    if !@@running
      @@width = width
      @@height = height
      @@running  = true

      push state

      on(State::Destroyed) do |state|
        puts "State destroyed #{state.class}"
        if state == main_state
          old = @@states.pop
          old.destroy
        else
          @@states.delete(state)
        end
      end

      Raylib.init_window(@@width, @@height, title)

      emit Game::Open

      until should_close?
        update
        draw
      end

      close
    else
      raise "Crixel is already running!"
    end
  end

  def self.title=(title)
    @@title = title
    Raylib.set_window_title(title)
  end

  def self.push(state : State)
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
    Raylib.begin_drawing
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