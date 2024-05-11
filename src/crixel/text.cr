class Crixel::Text < Crixel::Basic
  include IOBB

  property font : String = "default_rsrc/font.ttf"
  property text : String = ""
  property spacing : Float32 = 0.0_f32
  property tint : Raylib::Color = Raylib::Color.new(r: 0xFF, b: 0xFF, g: 0xFF, a: 0xFF)
  @height = 12

  def width
    Raylib.measure_text_ex(Assets.get_font(font), text, height, spacing).x
  end

  def width=(w)
    raise "Cannot set the width of a Crixel::Text"
  end

  def draw
    Raylib.draw_text_pro(Assets.get_font(font), text, position, origin, rotation*Raylib::RAD2DEG, height, spacing, tint)
  end
end