abstract class Crixel::Input::Poller
  def self.poll : Array(Input::IBase)
    [] of Input::IBase
  end

  macro inherited
    Crixel::Input::Manager.add_poll {{@type}}
  end
end

class Crixel::Key::Poller < Crixel::Input::Poller
  def self.poll : Array(Input::IBase)
    triggered_keys = [] of Input::IBase
    Keys.all.each do |key|
      key.poll
      triggered_keys << key if key.last_state? || key.current_state?
    end
    triggered_keys
  end
end

class Crixel::Gamepad::Button::Poller < Crixel::Input::Poller
  def self.poll : Array(Input::IBase)
    triggered_buttons = [] of Input::IBase
    Buttons.all.each do |button|
      button.poll
      triggered_buttons << button if button.last_state? || button.current_state?
    end
    triggered_buttons
  end
end

class Crixel::Mouse::Button::Poller < Crixel::Input::Poller
  def self.poll : Array(Input::IBase)
    triggered_buttons = [] of Input::IBase
    Buttons.all.each do |button|
      button.poll
      triggered_buttons << button if button.last_state? || button.current_state?
    end
    triggered_buttons
  end
end

class Crixel::Gamepad::Trigger::Poller < Crixel::Input::Poller
  def self.poll : Array(Input::IBase)
    triggers = [] of Input::IBase
    Triggers.all.each do |trigger|
      trigger.poll
      triggers << trigger if trigger.last_state? != trigger.current_state?
    end
    triggers
  end
end
