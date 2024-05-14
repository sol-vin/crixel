class Crixel::Gamepad::Button
  include Input::IButton

  enum Code
    Unknown        =  0
    LeftFaceUp     =  1
    LeftFaceRight  =  2
    LeftFaceDown   =  3
    LeftFaceLeft   =  4
    RightFaceUp    =  5
    RightFaceRight =  6
    RightFaceDown  =  7
    RightFaceLeft  =  8
    LeftTrigger1   =  9
    LeftTrigger2   = 10
    RightTrigger1  = 11
    RightTrigger2  = 12
    MiddleLeft     = 13
    Middle         = 14
    MiddleRight    = 15
    LeftThumb      = 16
    RightThumb     = 17
  end

  getter player : Player
  getter code : Code

  def initialize(@player, @code)
  end

  def poll(total_time : Time::Span, elapsed_time : Time::Span) : Nil
    _update_button(Raylib.gamepad_button_down?(@player.to_i, @code.to_i), total_time, elapsed_time)
  end
end
