require "./ibase"

module Crixel::Input::IButton
  include IBase

  getter? last_state : Bool = false
  getter? current_state : Bool = false
  getter? simulated_press : Bool = false

  event Pressed, input : self
  event Released, input : self
  event Down, input : self
  event Up, input : self

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

  private def _update_button(new_state)
    @last_state = @current_state
    @current_state = @simulated_press || new_state
    @simulated_press = false

    if pressed?
      emit Pressed, self
    elsif released?
      emit Released, self
    end

    if down?
      emit Down, self
    else
      emit Up, self
    end
  end
end
