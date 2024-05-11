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

  def poll : Nil
    _update_button(Raylib.mouse_button_down?(@code.to_i))
  end
end

module Crixel::Mouse::Buttons
  class_getter all = [] of Mouse::Button

  def self.setup
    Mouse::Button::Code.each do |button|
      @@all << Mouse::Button.new(Mouse::Button::Code.from_value(button.to_i))
    end
  end

  def self.get(button : Mouse::Button::Code)
    @@all.find { |b| b.code == button }.not_nil!
  end
end
