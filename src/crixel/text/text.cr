class Crixel::Text < Crixel::Basic
  def self.measure_text(font : String, text : String, height : Float32, spacing : Float32 = 0.0_f32)
    Raylib.measure_text_ex(Assets.get_rfont(font), text, height, spacing)
  end

  def self.draw(
    text : String,
    position : Vector2 = Vector2.zero,
    origin : Vector2 = Vector2.zero,
    rotation : Float32 = 0.0_f32,
    text_height = 12,
    spacing : Float32 = 0.0_f32,
    tint : Color = Color::RGBA::WHITE,
    font : String = "default_rsrc/font.ttf"
  )
    Raylib.draw_text_pro(Assets.get_rfont(font), text, position.to_raylib, origin.to_raylib, rotation, text_height, spacing, tint.to_raylib)
  end

  include IOBB

  property font : String = "default_rsrc/font.ttf"
  property text : String = ""
  property spacing : Float32 = 0.0_f32
  property tint : Color::RGBA = Color::RGBA::WHITE
  property text_size : Float32 = 12.0_f32

  def initialize(text = "", text_size = 12, @font = "default_rsrc/font.ttf", @tint = Color::RGBA::WHITE)
    @text_size = text_size

    self.text = text
  end

  def width
    Text.measure_text(font, text, @text_size, spacing).x
  end

  def height
    Text.measure_text(font, text, @text_size, spacing).y
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
    Text.draw(text, position, origin, rotation, text_size, spacing, tint, font)
  end
end
