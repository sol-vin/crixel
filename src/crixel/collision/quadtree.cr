class Crixel::QuadTree
  class Node
    include IBody         # Adds #x, #y, #width, #height
    alias ID = Crixel::ID # Just a UInt32
    getter id : ID
    getter depth : UInt32 = 0
    getter? divided = false

    property nw : Node?
    property ne : Node?
    property sw : Node?
    property se : Node?

    def nw!
      @nw.not_nil!
    end

    def ne!
      @ne.not_nil!
    end

    def sw!
      @sw.not_nil!
    end

    def se!
      @se.not_nil!
    end

    def initialize(@id, @depth, @x, @y, @width, @height)
    end

    def divide
      @divided = true
    end

    def draw(tint : Color = Color::RED)
      self.draw_body(tint)

      if divided?
        nw!.draw(tint)
        ne!.draw(tint)
        sw!.draw(tint)
        se!.draw(tint)
      end
    end

    def ==(other : Node)
      self.id = other.id
    end

    def hash
      @id.to_u64
    end
  end

  include IBody # Adds x, y, width, and height

  getter root : Node
  getter max_depth = 10
  getter max_children = 5

  # Returns the total amount of rectangle checks since generation
  getter total_checks = 0

  alias Objects = Hash(Crixel::ID, Basic)
  alias Nodes = Hash(Node::ID, Node)
  alias NodesChildren = Hash(Node::ID, Array(Crixel::ID))

  # All objects in the Q-tree
  @objects : Objects = Objects.new

  # All the leaf nodes of the Q-Tree and their children
  @nodes = Nodes.new
  @nodes_children = NodesChildren.new

  EMPTY_CHILDREN = Array(Crixel::ID).new

  def initialize(@x, @y, @width, @height)
    @root = Node.new(_get_id, 0, @x, @y, @width, @height)
  end

  def draw(color : Color = Color::BLUE)
    @nodes.each do |_, node|
      node.draw_body(color)
    end
  end

  def total_nodes
    @nodes.size
  end

  def total_rectangles
    total = 0
    max_depth.times { |x| total += 4**x }
    total
  end

  # Inserts an object into this quadtree
  def insert(object : Basic)
    raise "Not collidable" unless object.is_a?(Collidable)
    _insert_from(object, @root)
  end

  # Searches the QuadTree for all objects inside the rectangle
  def search(x, y, w, h, &block : Proc(Basic, Nil))
    _search(@root, x, y, w, h, &block)
  end

  def search(x, y, w, h)
    objects = [] of Basic
    _search(@root, x, y, w, h) { |o| objects << o }
    objects
  end

  # Checks which objects are colliding and allows a proc to manipulate them. Only produces one call to the proc per collision pair.
  def check(&block : Proc(Basic, Basic, Nil))
    total_matches = 0

    @nodes_children.each do |n_id, children|
      children.each_with_index do |o1_id, index|
        o1 = @objects[o1_id]
        b1 = o1.as(IBody)
        c1 = o1.as(Collidable)
        next unless c1.collidable?
        children[index + 1...children.size].each do |o2_id|
          o2 = @objects[o2_id]
          b2 = o2.as(IBody)
          c2 = o2.as(Collidable)
          total_matches += 1
          next unless c2.collidable?
          next unless c1.intersects? c2
          yield(o1, o2) if b1.intersects?(b2)
        end
      end
    end

    total_matches
  end

  private def _node_has_children?(node_id : Node::ID)
    @nodes_children[node_id]? && !@nodes_children[node_id].empty?
  end

  private def _node_has_children?(node : Node)
    _node_has_children?(node.id)
  end

  private def _get_node_children(node_id : Node::ID)
    if c = @nodes_children[node_id]?
      return c
    else
      return [] of Crixel::ID
    end
  end

  private def _get_node_children(node : Node)
    _get_node_children(node.id)
  end

  private def _get_node_child_count(node : Node)
    _get_node_child_count(node.id)
  end

  private def _get_node_child_count(node_id : Node::ID)
    @nodes_children[node_id]? ? @nodes_children[node_id].size : 0
  end

  private def _add_node(node : Node)
    @nodes[node.id] = node
  end

  private def _add_to_node(object : Basic, node : Node)
    @objects[object.id] = object
    object_bounds = object.as(IBody).to_rectangle

    @total_checks += 1
    if node.intersects?(object_bounds)
      if node.divided?
        _add_to_node(object, node.nw!)
        _add_to_node(object, node.ne!)
        _add_to_node(object, node.sw!)
        _add_to_node(object, node.se!)
      else
        @nodes_children[node.id] = Array(Crixel::ID).new unless @nodes_children[node.id]?
        @nodes_children[node.id] << object.id
      end
    end
  end

  private def _insert_from(object : Basic, node : Node)
    current_node : Node = node
    if ibody = object.as?(IBody)
      object_bounds = ibody.to_rectangle
      loop do
        # Drill down until we find a the smallest child that contains our object
        if current_node.divided?
          new_node = [current_node.nw!, current_node.ne!, current_node.sw!, current_node.se!].each.find do |c|
            @total_checks += 1
            c.contains? object_bounds
          end

          if n = new_node
            current_node = n
            next
          end
        end

        break
      end

      child_count = _get_node_child_count(current_node)

      # Check if we can divide this quad
      if !current_node.divided? && child_count + 1 > max_children && current_node.depth + 1 < max_depth
        to_process = _get_node_children(current_node)
        @nodes_children.delete(current_node.id)
        current_node.divide
        w = current_node.width/2
        h = current_node.height/2

        nw = Node.new(_get_id, current_node.depth + 1, current_node.x, current_node.y, w, h)
        ne = Node.new(_get_id, current_node.depth + 1, current_node.x + w, current_node.y, w, h)
        sw = Node.new(_get_id, current_node.depth + 1, current_node.x, current_node.y + h, w, h)
        se = Node.new(_get_id, current_node.depth + 1, current_node.x + w, current_node.y + h, w, h)

        current_node.nw = nw
        current_node.ne = ne
        current_node.sw = sw
        current_node.se = se

        _add_node(nw)
        _add_node(ne)
        _add_node(sw)
        _add_node(se)

        to_process.each { |child_id| _insert_from(@objects[child_id], current_node) }
        _insert_from(object, current_node)
        return
      end

      if current_node.divided?
        # Node is divided, so lets find what nodes actually intersect with it
        _add_to_node(object, current_node.nw!)
        _add_to_node(object, current_node.ne!)
        _add_to_node(object, current_node.sw!)
        _add_to_node(object, current_node.se!)
        return
      else
        # If we didnt divide it again (we already found the best container),
        # or we shouldn't because we dont have the max children (shouldnt divide)
        # or are the max level deep (cant divide)
        _add_to_node(object, current_node)
        return
      end
    else
      raise "NO BODY!"
    end
  end

  # Simple incrementing ID
  @current_id = 1_u32

  private def _get_id
    old = @current_id
    @current_id += 1
    return old
  end

  def _search(node : Node, x, y, w, h, &block : Proc(Basic, Nil))
    @total_checks += 1
    if node.intersects?(x, y, w, h)
      if node.divided?
        _search(node.nw!, x, y, w, h, &block)
        _search(node.ne!, x, y, w, h, &block)
        _search(node.sw!, x, y, w, h, &block)
        _search(node.se!, x, y, w, h, &block)
      else
        _get_node_children(node).each do |c_id|
          yield @objects[c_id]
        end
      end
    end
  end
end
