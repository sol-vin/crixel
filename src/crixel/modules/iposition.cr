module Crixel::IPosition
  property x : Float32 = 0.0_f32
  property y : Float32 = 0.0_f32

  def position : Vector2
    Vector2.new(x: x, y: y)
  end

  def position=(other : IPosition)
    position = other
  end

  def follow(x, y, speed = 1.0_f32)
    distance = Vector2.new((x - @x), (y - @y))
    @x += distance.x * speed
    @y += distance.y * speed
  end

  def follow(pos : IPosition, offset : IPosition = Vector2.zero, speed = 1.0_f32)
    follow(pos.x, pos.y, speed)
  end

  def follow(pos : Vector2, offset : IPosition = Vector2.zero, speed = 1.0_f32)
    follow(pos.x, pos.y, speed)
  end
end
