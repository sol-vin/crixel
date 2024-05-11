

abstract class Crixel::Input::Poller
  def self.poll : Array(Input::IBase)
    [] of Input::IBase
  end

  macro inherited
    Crixel::Input::Manager.add_poll {{@type}}
  end
end

module Crixel::Input::Keys
  class_getter all = [] of Crixel::Input::Key

  Raylib::KeyboardKey.each do |key|
    @@all << Crixel::Input::Key.new(key)
  end

  def self.get(key : Raylib::KeyboardKey)
    @@all.find {|k| k.keycode == key}.not_nil!
  end
end

class Crixel::Input::Poller::Button < Crixel::Input::Poller
  def self.poll : Array(Input::IBase)
    triggered_keys = [] of Input::IBase
    Keys.all.each do |key|
      key.poll
      triggered_keys << key if key.last_state? || key.current_state?
    end
    triggered_keys
  end
end