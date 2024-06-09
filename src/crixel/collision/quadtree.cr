class Crixel::QuadTree
  include IBody
  getter max_children = 5
  getter max_depth = 10

  getter current_depth = 0

  getter children = [] of Basic
  getter? divided = false
  
  getter nw : QuadTree?
  getter ne : QuadTree?
  getter sw : QuadTree?
  getter se : QuadTree?

  def initialize(@current_depth = 0, @max_depth = 10)
  end

  def includes?(child : Basic)
    @children.includes?(child)
  end

  def intersects?(other : Basic)
    case other
    when .is_a?(IOBB) then return self.intersects?(other.as(IOBB).bounding_box) # TODO: Fix this by adding SAT? Better check against AABB?
    when .is_a?(IBody) then return self.intersects?(other.as(IBody))
    when .is_a?(IPosition) then return self.contains?(other.as(IPosition))
    else return false
    end
  end

  def insert(child : Basic)
    raise("Not insertable here (doesnt have a shape)") unless child.is_a?(IOBB | IBody | IPosition) #TODO: Fix this with collision_shape in Colliable
    raise("Not insertable here (is not Collidable)") unless child.is_a?(Collidable)

    if divided?
      bounds = _get_bounding_box(child)
      @nw.not_nil!.insert(child) if bounds.intersects?(@nw.not_nil!)
      @ne.not_nil!.insert(child) if bounds.intersects?(@ne.not_nil!)
      @sw.not_nil!.insert(child) if bounds.intersects?(@sw.not_nil!)
      @se.not_nil!.insert(child) if bounds.intersects?(@se.not_nil!)
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
    nw = QuadTree.new(current_depth: @current_depth + 1)
    nw.x, nw.y, nw.width, nw.height = x, y, w, h
    ne = QuadTree.new(current_depth: @current_depth + 1)
    ne.x, ne.y, ne.width, ne.height = x + w, y, w, h
    sw = QuadTree.new(current_depth: @current_depth + 1)
    sw.x, sw.y, sw.width, sw.height = x, y + h, w, h
    se = QuadTree.new(current_depth: @current_depth + 1)
    se.x, se.y, se.width, se.height = x + w, y + h, w, h

    @nw = nw
    @ne = ne
    @sw = sw
    @se = se

    @children.each do |child|
      bounds = _get_bounding_box(child)
      @nw.not_nil!.insert(child) if bounds.intersects?(@nw.not_nil!)
      @ne.not_nil!.insert(child) if bounds.intersects?(@ne.not_nil!)
      @sw.not_nil!.insert(child) if bounds.intersects?(@sw.not_nil!)
      @se.not_nil!.insert(child) if bounds.intersects?(@se.not_nil!)
    end

    # @children.clear
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

  def each(&block : Proc(QuadTree, Nil))
    qts = [self] of QuadTree

    loop do
      current_qt = qts.pop
      if current_qt.divided?
        qts.concat [
          current_qt.nw.not_nil!,
          current_qt.ne.not_nil!,
          current_qt.sw.not_nil!,
          current_qt.se.not_nil!
        ]
      else
        yield current_qt
      end

      break if qts.empty?
    end
  end

  def check(&block : Proc(Basic, Basic, Nil))
    self.each do |qt|
      qt.children[0...(qt.children.size-1)].each_with_index do |child1, index|
        qt.children[(index+1)...qt.children.size].each do |child2|
          c1 = child1.as(Collidable)
          c2 = child2.as(Collidable)

          next unless c1.collision_mask.intersects?(c2.collision_mask)

          # Broadphase
          bounds1 = _get_bounding_box(child1)
          bounds2 = _get_bounding_box(child2)
          next unless bounds1.intersects?(bounds2)

          #Narrowphase
          #TODO: Write this

          yield child1, child2
        end
      end
    end
  end

  private def _get_bounding_box(object : Basic)      
    case object
      when .is_a?(IOBB) then return object.as(IOBB).bounding_box
      when .is_a?(IBody) then return object.as(IBody)
      when .is_a?(IPosition) then return Rectangle.new(object.as(IPosition).position, 1, 1)
      else
        raise("Impossible: A Basic without a shape somehow got in here")
    end
  end
end