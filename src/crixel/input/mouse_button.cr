class Crixel::Mouse::Button
  include Input::IButton

  enum Code
    Left    = 0
    Right   = 1
    Middle  = 2
    Side    = 3
    Extra   = 4
    Forward = 5
    Back    = 6
  end

  getter code : Code

  def initialize(@code)
  end

  def poll(total_time : Time::Span, elapsed_time : Time::Span) : Nil
    _update_button(Raylib.mouse_button_down?(@code.to_i), total_time, elapsed_time)
  end
end
