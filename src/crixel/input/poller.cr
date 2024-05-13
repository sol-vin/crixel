abstract class Crixel::Input::Poller
  def self.poll(state : State) : Array(Input::IBase)
    [] of Input::IBase
  end

  macro inherited
    Crixel::Input::Manager.add_poll {{@type}}
  end
end

class Crixel::Key::Poller < Crixel::Input::Poller
  def self.poll(state : State) : Array(Input::IBase)
    triggered_keys = [] of Input::IBase
    state.inputs.keys.each do |key|
      key.poll
      triggered_keys << key if key.last_state? || key.current_state?
    end
    triggered_keys
  end
end

class Crixel::Gamepad::Button::Poller < Crixel::Input::Poller
  def self.poll(state : State) : Array(Input::IBase)
    triggered_buttons = [] of Input::IBase
    state.inputs.buttons.each do |button|
      button.poll
      triggered_buttons << button if button.last_state? || button.current_state?
    end
    triggered_buttons
  end
end

class Crixel::Mouse::Button::Poller < Crixel::Input::Poller
  def self.poll(state : State) : Array(Input::IBase)
    triggered_buttons = [] of Input::IBase
    state.inputs.mouse_buttons.each do |button|
      button.poll
      triggered_buttons << button if button.last_state? || button.current_state?
    end
    triggered_buttons
  end
end

class Crixel::Gamepad::Trigger::Poller < Crixel::Input::Poller
  def self.poll(state : State) : Array(Input::IBase)
    triggers = [] of Input::IBase
    state.inputs.triggers.each do |trigger|
      trigger.poll
      triggers << trigger if trigger.last_value != trigger.current_value
    end
    triggers
  end
end

class Crixel::Gamepad::AnalogStick::Poller < Crixel::Input::Poller
  def self.poll(state : State) : Array(Input::IBase)
    sticks = [] of Input::IBase
    state.inputs.analog_sticks.each do |stick|
      stick.poll
      sticks << stick if stick.last_value != stick.current_value
    end
    sticks
  end
end
