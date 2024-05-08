require "minievents"
MiniEvents.install(::Crixel::Event)

require "./crixel/state"
require "./crixel/machine"

module Crixel
  VERSION = "0.0.1"
  VERSION_STATE = "alpha"

  class_getter width : Int32 = 0
  class_getter height : Int32 = 0
  class_getter? running = false

  @@states = [] of State

  event Game::Pop, state : State
  event Game::Push, state : State
  event Game::Open
  event Game::Close

  def self.run(width, height, state)
    @@width = width
    @@height = height
    @@running  = true

    push state

    on(State::Destroyed) do |state|
      puts "State destroyed #{state.class}"
      if state == main_state
        old = @@states.pop
        emit State::IsMain, main_state
      else
        @@states.delete(state)
      end
    end

    emit Game::Open
  end

  def self.push(state : State)
    @@states.push state
    emit Game::Push, state
    emit State::IsMain, state
  end

  def self.pop
    state = @@states.pop
    emit State::IsMain, main_state
    emit Game::Pop, state
  end

  def self.main_state
    @@states.last
  end

  def self.update
    @@states.reverse_each.with_index do |state, count|
      index = (states.size - 1) - count

      # Check if we are the top state
      if index == (states.size - 1) 
        state.update
      else
        state.update if state.persist_update
      end
    end
  end

  def self.draw
    @@states.reverse_each.with_index do |state, count|
      index = (states.size - 1) - count

      # Check if we are the top state
      if index == (states.size - 1) 
        state.draw
      else
        state.draw if state.persist_draw
      end
    end
  end

  def self.close
    @@running = false
    emit Game::Close
  end
end