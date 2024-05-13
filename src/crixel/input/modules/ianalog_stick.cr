require "./ibase"

module Crixel::Input::IAnalogStick
  include IBase

  getter last_value : Vector2 = Vector2.zero
  getter current_value : Vector2 = Vector2.zero

  getter simulated_move : Vector2 = Vector2.zero

  getter min_moved = 0.02_f32

  event Moved, input : self

  private def _update_analog_stick(value : Vector2)
    @last_value = @current_value

    @current_value.x = (@simulated_move.x > 0) ? @simulated_move.x : value.x
    @current_value.y = (@simulated_move.y > 0) ? @simulated_move.y : value.y

    @simulated_move = Vector2.zero

    if (@last_value.x - @current_value.x).abs + (@last_value.y - @current_value.y).abs > @min_moved
      emit Moved, self
    end
  end
end
