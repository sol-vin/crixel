module Crixel::ISize
  property width : Float32 = 0.0_f32
  property height : Float32 = 0.0_f32

  def size_invalid?
    width <= 0 || height <= 0
  end

  def size_null?
    width.abs == 0 || height.abs == 0
  end
end
