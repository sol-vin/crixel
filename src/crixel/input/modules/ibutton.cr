require "./ibase"

module Crixel::Input::IButton
  include IBase

  getter? last_state : Bool = false
  getter? current_state : Bool = false
  getter? simulated_press : Bool = false

  event Pressed, input : self, total_time : Time::Span, elapsed_time : Time::Span
  event Released, input : self, total_time : Time::Span, elapsed_time : Time::Span
  event Down, input : self, total_time : Time::Span, elapsed_time : Time::Span
  event Up, input : self, total_time : Time::Span, elapsed_time : Time::Span

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

  private def _update_button(new_state, total_time : Time::Span, elapsed_time : Time::Span)
    @last_state = @current_state
    @current_state = @simulated_press || new_state
    @simulated_press = false

    if pressed?
      emit Pressed, self, total_time, elapsed_time
    elsif released?
      emit Released, self, total_time, elapsed_time
    end

    if down?
      emit Down, self, total_time, elapsed_time
    else
      emit Up, self, total_time, elapsed_time
    end
  end
end
