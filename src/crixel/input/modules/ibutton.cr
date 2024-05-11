require "./ibase"

module Crixel::Input::IButton
  include IBase

  getter? last_state : Bool = false
  getter? current_state : Bool = false
  getter? simulated_press : Bool = false

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

  private def _update(new_state)
    @last_state = @current_state
    @current_state = @simulated_press || new_state

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