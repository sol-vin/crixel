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

module Crixel::Gamepad::Triggers
  class_getter all = [] of Trigger

  def self.setup
    players = [] of Player

    Player.each do |player|
      if player.available?
        players << player
      end
    end

    Trigger::Code.each do |code|
      players.each do |player|
        @@all << Trigger.new(player, Trigger::Code.from_value(code.to_i))
      end
    end
  end

  def self.get(player : Player, code : Trigger::Code)
    button = @@all.find { |b| b.code == code && b.player == player }
    raise "Player #{player} did not exist :(" if button.nil?
    button.not_nil!
  end
end
