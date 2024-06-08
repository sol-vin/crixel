class Crixel::QuadTree
  include IBody
  getter max_children = 10
  getter max_depth = 10

  getter current_depth = 0

  getter children = Set(Basic).new
  getter? divided = false
  
  getter nw : Quad?
  getter ne : Quad?
  getter sw : Quad?
  getter se : Quad?

  def initialize(@current_depth = 0, @max_depth = 10)
  end

  def includes?(child : Basic)
    children.includes?(child)
  end

  def intersects?(other : Basic)
    case other
    when .is_a?(IOBB) then return false #TODO: Fix this
    when .is_a?(IBody) then return self.intersects?(other.as(IBody))
    when .is_a?(IPosition) then return self.intersects?(other.as(IPosition))
    else return false
    end
  end

  
  def inside?(other : Basic)
    case other
    when .is_a?(IOBB) then return other.as(IOBB).bounding_box.points.all? {|v| v.x >= left && v.x <= right && v.y >= top && v.y <= bottom}
    when .is_a?(IBody) then return other.as(IBody).points.all? {|v| v.x >= left && v.x <= right && v.y >= top && v.y <= bottom}
    when .is_a?(IPosition) then return self.intersects?(other.as(IPosition))
    else return false
    end
  end

  def insert(child : Basic)
    if divided?
      @nw.not_nil!.insert(child) if bounds.intersects(@nw)
      @ne.not_nil!.insert(child) if bounds.intersects(@ne)
      @sw.not_nil!.insert(child) if bounds.intersects(@sw)
      @se.not_nil!.insert(child) if bounds.intersects(@se)
    else
      @children << child

      subdivide if @children.size > max_children
    end
  end
  
  def subdivide
    return if @current_depth + 1 > max_depth
    @divided = true
    w = width/2
    h = height/2
    nw = Quad.new(current_depth: @current_depth + 1)
    nw.x, nw.y, nw.width, nw.height = x, y, w, h
    ne = Quad.new(current_depth: @current_depth + 1)
    ne.x, ne.y, ne.width, ne.height = x + w, y, w, h
    sw = Quad.new(current_depth: @current_depth + 1)
    sw.x, sw.y, sw.width, sw.height = x, y + h, w, h
    se = Quad.new(current_depth: @current_depth + 1)
    sw.x, sw.y, sw.width, sw.height = x + w, y + h, w, h

    @nw = nw
    @ne = ne
    @sw = sw
    @se = se

    children.each do |child|
      bounds = _get_bounding_box(child)
      @nw.not_nil!.insert(child) if bounds.intersects(@nw)
      @ne.not_nil!.insert(child) if bounds.intersects(@ne)
      @sw.not_nil!.insert(child) if bounds.intersects(@sw)
      @se.not_nil!.insert(child) if bounds.intersects(@se)
    end

    children.clear
  end

  def draw(tint : Color = Color::WHITE)
    draw_body(tint)
    if divided?
      @nw.not_nil!.draw(tint)
      @ne.not_nil!.draw(tint)
      @sw.not_nil!.draw(tint)
      @se.not_nil!.draw(tint)
    end
  end

  private def _get_bounding_box(object : Basic)      
    case child
      when .is_a?(IOBB) then return object.as(IOBB).bounding_box
      when .is_a?(IBody) then return object.as(IBody)
      when .is_a?(IPosition) then return Rectangle.new(object.as(IPosition).position, 1, 1) 
    end
  end
end