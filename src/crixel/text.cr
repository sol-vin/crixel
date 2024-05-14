class Crixel::Text < Crixel::Basic
  include IOBB

  property font : String = "default_rsrc/font.ttf"
  property text : String = ""
  property spacing : Float32 = 0.0_f32
  property tint : Color::RGBA = Color::RGBA.new(r: 0xFF, b: 0xFF, g: 0xFF, a: 0xFF)
  @height = 12

  def width
    Raylib.measure_text_ex(Assets.get_rfont(font), text, height, spacing).x
  end

  def width=(w)
    raise "Cannot set the width of a Crixel::Text"
  end

  def draw(elapsed_time : Time::Span)
    Raylib.draw_text_pro(Assets.get_rfont(font), text, position.to_raylib, origin.to_raylib, rotation*Raylib::RAD2DEG, height, spacing, tint.to_raylib)
  end
end
