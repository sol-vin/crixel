require "./ibase"

module Crixel::Input::IAnalogStick
  include IBase

  getter last_value : Vector2 = Vector2.zero
  getter current_value : Vector2 = Vector2.zero

  getter simulated_move : Vector2 = Vector2.zero

  getter min_moved = 0.02_f32

  single_event Moved, input : self, total_time : Time::Span, elapsed_time : Time::Span

  private def _update_analog_stick(value : Vector2, total_time : Time::Span, elapsed_time : Time::Span)
    @last_value = @current_value

    @current_value.x = (@simulated_move.x > 0) ? @simulated_move.x : value.x
    @current_value.y = (@simulated_move.y > 0) ? @simulated_move.y : value.y

    @simulated_move = Vector2.zero

    if (@last_value.x - @current_value.x).abs + (@last_value.y - @current_value.y).abs > @min_moved
      emit Moved, self, total_time, elapsed_time
    end
  end
end
