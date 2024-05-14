class Crixel::Gamepad::AnalogStick
  include Input::IAnalogStick

  enum Code
    Left  = 0
    Right = 1
  end

  getter player : Player
  getter code : Code

  def initialize(@player, @code)
  end

  def poll(total_time : Time::Span, elapsed_time : Time::Span) : Nil
    x_axis = (@code == Code::Left) ? Raylib::GamepadAxis::LeftX : Raylib::GamepadAxis::RightX
    y_axis = (@code == Code::Left) ? Raylib::GamepadAxis::LeftY : Raylib::GamepadAxis::RightY

    position = Vector2.zero
    position.x = Raylib.get_gamepad_axis_movement(@player.to_i, x_axis)
    position.y = Raylib.get_gamepad_axis_movement(@player.to_i, y_axis)

    _update_analog_stick(position, total_time, elapsed_time)
  end
end
