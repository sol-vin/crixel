require "./crixel/event"
install_events(Crixel::Event, Crixel::Events)

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

  def self.run(width, height)
    @@width = width
    @@height = height
    @@running  = true

    emit OpenGame
  end

  def self.push(state : State)
    @states.push state
    emit PushState, state
  end

  def self.pop
    state = @states.pop
    emit PopState, state
  end

  def self.update
  end

  def self.draw
  end

  def self.close
    @@running = false
    emit CloseGame
  end
end