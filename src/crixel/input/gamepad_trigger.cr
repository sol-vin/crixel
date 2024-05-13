class Crixel::Gamepad::Trigger
  include Input::ITrigger

  enum Code
    # LeftX        = 0
    # LeftY        = 1
    # RightX       = 2
    # RightY       = 3
    Left  = 4
    Right = 5
  end

  getter player : Player
  getter code : Code

  def initialize(@player, @code)
  end

  def poll : Nil
    _update_trigger((Raylib.get_gamepad_axis_movement(@player.to_i, @code.to_i) + 1)/2.0_f32.clamp(0, 1.0_f32))
  end
end
