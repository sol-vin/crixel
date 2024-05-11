enum Crixel::Gamepad::Player
  One   = 0
  Two   = 1
  Three = 2
  Four  = 3

  def available?
    Raylib.gamepad_available?(self.value)
  end
end
