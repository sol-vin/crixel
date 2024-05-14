require "./input/**"

class Crixel::Inputs
  getter keys = [] of Key
  getter triggers = [] of Gamepad::Trigger
  getter buttons = [] of Gamepad::Button
  getter analog_sticks = [] of Gamepad::AnalogStick
  getter mouse_buttons = [] of Mouse::Button

  def setup
    Raylib.poll_input_events

    Key::Code.each do |key|
      @keys << Key.new(Key::Code.from_value(key.to_i))
    end

    Mouse::Button::Code.each do |button|
      @mouse_buttons << Mouse::Button.new(Mouse::Button::Code.from_value(button.to_i))
    end

    players = [] of Gamepad::Player

    Gamepad::Player.each do |player|
      if player.available?
        players << player
      end
    end

    Gamepad::AnalogStick::Code.each do |code|
      players.each do |player|
        @analog_sticks << Gamepad::AnalogStick.new(player, Gamepad::AnalogStick::Code.from_value(code.to_i))
      end
    end

    Gamepad::Button::Code.each do |code|
      players.each do |player|
        @buttons << Gamepad::Button.new(player, Gamepad::Button::Code.from_value(code.to_i))
      end
    end

    Gamepad::Trigger::Code.each do |code|
      players.each do |player|
        @triggers << Gamepad::Trigger.new(player, Gamepad::Trigger::Code.from_value(code.to_i))
      end
    end
  end

  def get_key(key : Key::Code)
    @keys.find { |k| k.code == key }.not_nil!
  end

  def get_mouse_button(button : Mouse::Button::Code)
    @mouse_buttons.find { |b| b.code == button }.not_nil!
  end

  def get_analog_stick(player : Gamepad::Player, code : Gamepad::AnalogStick::Code)
    stick = @analog_sticks.find { |s| s.code == code && s.player == player }
    raise "Player #{player} did not exist :(" if stick.nil?
    stick.not_nil!
  end

  def get_button(player : Gamepad::Player, code : Gamepad::Button::Code)
    button = @buttons.find { |b| b.code == code && b.player == player }
    raise "Player #{player} did not exist :(" if button.nil?
    button.not_nil!
  end

  def get_trigger(player : Gamepad::Player, code : Gamepad::Trigger::Code)
    button = @triggers.find { |b| b.code == code && b.player == player }
    raise "Player #{player} did not exist :(" if button.nil?
    button.not_nil!
  end
end

class Crixel::State
  getter inputs : Crixel::Inputs = Crixel::Inputs.new

  on(State::PreSetup) do |state|
    state.inputs.setup
  end

  def update(total_time : Time::Span, elapsed_time : Time::Span)
    Input::Manager.update(self, total_time, elapsed_time)
    previous_def # TODO: This MAY cause problems in the future?
  end
end
