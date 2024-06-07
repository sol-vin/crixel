module Crixel::Collidable
  property collision_mask = Set(Symbol).new
  property? collidable = true

  # def get_shape : Class
  #   case self
  #   when .is_a?(IOBB) then return IOBB
  #   when .is_a?(IBody) then return IBody
  #   end
  # end
end