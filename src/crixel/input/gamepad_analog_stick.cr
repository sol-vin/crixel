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

  def poll : Nil
    x_axis = (@code == Code::Left) ? Raylib::GamepadAxis::LeftX : Raylib::GamepadAxis::RightX
    y_axis = (@code == Code::Left) ? Raylib::GamepadAxis::LeftY : Raylib::GamepadAxis::RightY

    position = Vector2.zero
    position.x = Raylib.get_gamepad_axis_movement(@player.to_i, x_axis)
    position.y = Raylib.get_gamepad_axis_movement(@player.to_i, y_axis)

    _update_analog_stick(position)
  end
end

module Crixel::Gamepad::AnalogSticks
  class_getter all = [] of AnalogStick

  def self.setup
    players = [] of Player

    Player.each do |player|
      if player.available?
        players << player
      end
    end

    AnalogStick::Code.each do |code|
      players.each do |player|
        @@all << AnalogStick.new(player, AnalogStick::Code.from_value(code.to_i))
      end
    end
  end

  def self.get(player : Player, code : AnalogStick::Code)
    stick = @@all.find { |s| s.code == code && s.player == player }
    raise "Player #{player} did not exist :(" if stick.nil?
    stick.not_nil!
  end
end
