struct Crixel::Rectangle
  property x : Float32 = 0.0_f32
  property y : Float32 = 0.0_f32
  property width : Float32 = 0.0_f32
  property height : Float32 = 0.0_f32

  def initialize(x : Number = 0.0_f32, y : Number = 0.0_f32, width : Number = 0.0_f32, height : Number = 0.0_f32)
    @x = x.to_f32
    @y = y.to_f32
    @width = width.to_f32
    @height = height.to_f32
  end

  def to_raylib : Raylib::Color
    Raylib::Rectangle.new(
      x: x,
      y: y,
      width: width,
      height: height
    )
  end
end
