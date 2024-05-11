require "./ibase"

module Crixel::Input::ITrigger
  include IButton

  abstract def value : Float32
end
