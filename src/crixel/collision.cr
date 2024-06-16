require "./collision/node"
require "./collision/quadtree"

module Crixel::Collidable
  property collision_mask = Set(Symbol).new
  property? collidable = true
end
