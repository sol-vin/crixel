module Crixel::Input::Manager
  @@pollers = [] of Input::Poller.class

  class_getter last_inputs : Array(Input::IBase) = [] of Input::IBase

  def self.add_poll(poller : Input::Poller.class)
    @@pollers << poller
  end

  def self.update
    @@last_inputs.clear
    @@pollers.each do |poller|
      inputs = poller.poll
      @@last_inputs.concat inputs
    end
  end
end