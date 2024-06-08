module Crixel::Collidable
  SHAPES = [Rectangle, Circle]
  alias Shape = Rectangle | Circle
  
  property collision_mask = Set(Symbol).new
  property? collidable = true
  property? collision_shape : Shape = Circle.new
  
end