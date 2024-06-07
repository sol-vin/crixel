class Crixel::QuadTree
  class Quad
    include IBody
    getter children = Set(Basic).new

    def includes?(child : Basic)
      children.includes?(child)
    end

    def intersects?(other : Basic)
      case other
      when .is_a?(IOBB) then return false #TODO: Fix this
      when .is_a?(IBody) then return self.intersects?(other.as(IBody))
      when .is_a?(IPosition) then return self.intersects?(other.as(IPosition))
      end
    end

    
    def inside?(other : Basic)
      case other
      when .is_a?(IOBB) then return other.as(IOBB).bounding_box.points.all? {|v| v.x >= left && v.x <= right && v.y >= top && v.y <= bottom}
      when .is_a?(IBody) then return other.as(IBody).points.all? {|v| v.x >= left && v.x <= right && v.y >= top && v.y <= bottom}
      when .is_a?(IPosition) then return self.intersects?(other.as(IPosition))
      end
    end
  end

  getter max_depth = 5

  def initialize(@max_depth = 5)
  end
end