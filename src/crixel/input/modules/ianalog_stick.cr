require "./ibase"

module Crixel::Input::IAnalogStick
  include IBase

  abstract def x : Float32
  abstract def y : Float32
end
