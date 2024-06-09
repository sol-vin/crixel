class Crixel::QuadTree
  include IBody
  getter max_children = 5
  getter max_depth = 6

  getter current_depth = 0

  getter children = [] of Basic
  getter? divided = false
  
  getter nw : QuadTree?
  getter ne : QuadTree?
  getter sw : QuadTree?
  getter se : QuadTree?

  getter total_checks = 0

  def initialize(@current_depth = 0, @max_depth = 6)
  end

  def includes?(child : Basic)
    @children.includes?(child)
  end

  def insert(child : Basic)
    raise("Not insertable here (doesnt have a shape)") unless child.is_a?(IBody)
    raise("Not insertable here (is not Collidable)") unless child.is_a?(Collidable)

    if divided?
      bounds = child.as(IBody)
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
      bounds = child.as(IBody)
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

  def query(x, y, w, h) : Array(Basic)
    output = [] of Basic
    if self.contained_by?(x, y, w, h)
      # Fully contained by the query so all children are intersecting
      output.concat children
    elsif self.intersects?(x, y, w, h)
      if self.divided?
        # Recursive call for query since we are divided
        output.concat @nw.not_nil!.query(x, y, w, h)
        output.concat @ne.not_nil!.query(x, y, w, h)
        output.concat @sw.not_nil!.query(x, y, w, h)
        output.concat @se.not_nil!.query(x, y, w, h)
      else
        # Not divided, so just check the items in here for intersection
        output.concat children.select {|c| c.as(IBody).intersects?(x, y, w, h)}
      end
    end
    output
  end

  def check(&block : Proc(Basic, Basic, Nil))
    self.each do |qt|
      qt.children[0...(qt.children.size-1)].each_with_index do |child1, index|
        qt.children[(index+1)...qt.children.size].each do |child2|
          @total_checks += 1
          c1 = child1.as(Collidable)
          c2 = child2.as(Collidable)

          next unless c1.collision_mask.intersects?(c2.collision_mask)

          # Broadphase
          bounds1 = child1.as(IBody)
          bounds2 = child1.as(IBody)
          next unless bounds1.intersects?(bounds2)

          #Narrowphase
          #TODO: Write this

          yield child1, child2
        end
      end
    end
  end
end