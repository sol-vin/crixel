abstract struct Crixel::Color
  abstract def to_rgba : RGBA
end

struct Crixel::Color::RGBA < Crixel::Color
  RED     = Crixel::Color::RGBA.new(r: 255, a: 255)
  YELLOW  = Crixel::Color::RGBA.new(r: 255, g: 255, a: 255)
  GREEN   = Crixel::Color::RGBA.new(g: 255, a: 255)
  CYAN    = Crixel::Color::RGBA.new(g: 255, b: 255, a: 255)
  BLUE    = Crixel::Color::RGBA.new(b: 255, a: 255)
  MAGENTA = Crixel::Color::RGBA.new(r: 255, b: 255, a: 255)
  WHITE   = Crixel::Color::RGBA.new(r: 255, g: 255, b: 255, a: 255)
  BLACK   = Crixel::Color::RGBA.new(r: 0, g: 0, b: 0, a: 255)
  CLEAR   = Crixel::Color::RGBA.new(r: 0, g: 0, b: 0, a: 0)

  property r : UInt8 = 0_u8
  property g : UInt8 = 0_u8
  property b : UInt8 = 0_u8
  property a : UInt8 = 0_u8

  def initialize(r : Number = 0_u8, g : Number = 0_u8, b : Number = 0_u8, a : Number = 0_u8)
    @r = r.to_u8
    @g = g.to_u8
    @b = b.to_u8
    @a = a.to_u8
  end

  def to_raylib : Raylib::Color
    Raylib::Color.new(r: r, g: g, b: b, a: a)
  end

  def to_rgba : RGBA
    self
  end
end
