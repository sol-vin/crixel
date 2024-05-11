
module Crixel::Input::IBase
  abstract def poll : Nil
end

module Crixel::Input::IButton
  include IBase

  getter? last_state : Bool = false
  getter? current_state : Bool = false

  abstract def press

  abstract def pressed? : Bool
  abstract def released? : Bool
  abstract def down? : Bool
  abstract def up? : Bool

  private def _update(new_state)
    @last_state = @current_state
    @current_state = new_state

    if pressed?
      emit_pressed
    elsif released?
      emit_released
    end

    if down?
      emit_down
    else
      emit_up
    end
  end

  event Pressed, input : self
  event Released, input : self
  event Down, input : self
  event Up, input : self

  attach_self Pressed
  attach_self Released
  attach_self Down
  attach_self Up
end

class Crixel::Input::Key
  include IButton

  getter keycode = Raylib::KeyboardKey::Null

  @last_state = false
  @current_state = false

  @simulated_press = false

  def initialize(@keycode)
  end

  def poll : Nil
    if @simulated_press
      _update(true)
      @simulated_press = false
    else
      _update(Raylib.key_down?(@keycode))
    end
  end

  def press
    @simulated_press = true
  end

  def pressed? : Bool
    !@last_state && @current_state
  end

  def released? : Bool
    @last_state && !@current_state
  end

  def down? : Bool
    @last_state && @current_state
  end

  def up? : Bool
    !@last_state && !@current_state
  end
end

module Crixel::Input::ITrigger
  include IButton
  abstract def value : Float32
end

module Crixel::Input::IAnalogStick
  include IBase

  abstract def x : Float32
  abstract def y : Float32
end