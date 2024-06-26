require "./ibase"

module Crixel::Input::ITrigger
  include IButton

  getter last_value : Float32 = 0.0_f32
  getter current_value : Float32 = 0.0_f32

  getter simulated_move : Float32 = 0.0_f32

  property press_limit = 0.5_f32

  single_event Moved, input : self, total_time : Time::Span, elapsed_time : Time::Span

  private def _update_trigger(value : Float32, total_time : Time::Span, elapsed_time : Time::Span)
    @last_value = @current_value
    @current_value = (@simulated_press ? 1.0_f32 : (@simulated_move > 0) ? @simulated_move : value)
    @simulated_move = 0.0_f32

    if @current_value > press_limit
      _update_button(true, total_time, elapsed_time)
    else
      _update_button(false, total_time, elapsed_time)
    end

    if @current_value > 0
      emit Moved, self, total_time, elapsed_time
    end
  end
end
