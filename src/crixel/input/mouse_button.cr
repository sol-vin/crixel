class Crixel::MouseButton
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

  def poll : Nil
    _update(Raylib.mouse_button_down?(@code.to_i))
  end
end

module Crixel::MouseButtons
  class_getter all = [] of MouseButton

  def self.setup
    Raylib::MouseButton.each do |button|
      @@all << MouseButton.new(MouseButton::Code.from_value(button.to_i))
    end
  end

  def self.get(button : MouseButton::Code)
    @@all.find { |b| b.code == button }.not_nil!
  end
end
