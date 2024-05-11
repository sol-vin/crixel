class Crixel::GamepadButton
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

  getter player : Gamepad::Player
  getter code : Code

  def initialize(@player, @code)
  end

  def poll : Nil
    _update(Raylib.gamepad_button_down?(@player.to_i, @code.to_i))
  end
end

module Crixel::GamepadButtons
  class_getter all = [] of GamepadButton

  def self.setup
    # Polls input
    Raylib.poll_input_events

    players = [] of Gamepad::Player

    Gamepad::Player.each do |player|
      if player.available?
        players << player
      end
    end

    puts players

    Raylib::GamepadButton.each do |code|
      players.each do |player|
        @@all << GamepadButton.new(player, GamepadButton::Code.from_value(code.to_i))
      end
    end
  end

  def self.get(player : Gamepad::Player, code : GamepadButton::Code)
    button = @@all.find { |b| b.code == code && b.player == player }
    raise "Player #{player} did not exist :(" if button.nil?
    button.not_nil!
  end
end
