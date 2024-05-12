struct Crixel::Color::RGBA
  property r : UInt8 = 0_u8
  property g : UInt8 = 0_u8
  property b : UInt8 = 0_u8
  property a : UInt8 = 0_u8

  def initialize(@r = 0_u8, @g = 0_u8, @b = 0_u8, @a = 0_u8)
  end

  def to_raylib : Raylib::Color
    Raylib::Color.new(r: r, g: g, b: b, a: a)
  end
end
