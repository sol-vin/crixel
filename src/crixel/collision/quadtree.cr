class Crixel::QuadTree
  class Node
    include IBody # Adds #x, #y, #width, #height
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

  include IBody

  getter root : Node
  getter max_depth = 10
  getter max_children = 5

  # Returns the total amount of rectangle checks since generation
  getter total_checks = 0

  alias Objects = Hash(Crixel::ID, Basic)
  alias ObjectsContainers = Hash(Crixel::ID, Node)
  alias Nodes = Hash(Node::ID, Node)
  alias NodesChildren = Hash(Node::ID, Set(Crixel::ID))


  # All objects in the Q-tree
  @objects : Objects = Objects.new
  @objects_containers = ObjectsContainers.new

  # All the leaf nodes of the Q-Tree and their children
  @nodes = Nodes.new
  @nodes_children = NodesChildren.new

  EMPTY_CHILDREN = Set(Node::ID).new

  def initialize(@x, @y, @width, @height)
    @root = Node.new(_get_id, 0, @x, @y, @width, @height)
  end

  
  def draw(no_items_color : Color = Color::RED, items_color : Color = Color::BLUE)
    @root.draw(no_items_color)

    @nodes.each do |_, node|
      node.draw_body(items_color)
    end
  end

  def total_nodes
    @nodes.size
  end
   
  def total_rectangles
    total = 0
    max_depth.times { |x| total += 4**x}
    total
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
      EMPTY_CHILDREN
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
    @objects_containers[object.id] = node
    @nodes_children[node.id] = Set(Crixel::ID).new unless @nodes_children[node.id]?
    children = @nodes_children[node.id]
    children << object.id
    children.size
  end

  private def _insert_from(object : Basic, node : Node) : Node
    current_node : Node = node

    loop do
      # Drill down until we find a the smallest child that contains our object
      if current_node.divided?
        new_node = [current_node.nw!, current_node.ne!, current_node.sw!, current_node.se!].each.find do |c| 
          @total_checks += 1
          c.contains? object.as(IBody)
        end
        
        if n = new_node
          current_node = n
          next
        end
      end

      child_count = _get_node_child_count(current_node)

      # Check if we can divide this quad
      if !current_node.divided? && child_count + 1 > max_children && current_node.depth + 1 < max_depth
        to_process = _get_node_children(current_node)
        @nodes_children[current_node.id] = Set(Crixel::ID).new
        current_node.divide
        w = current_node.width/2
        h = current_node.height/2

        nw = Node.new(_get_id, current_node.depth+1, current_node.x, current_node.y, w, h)
        ne = Node.new(_get_id, current_node.depth+1, current_node.x + w, current_node.y, w, h)
        sw = Node.new(_get_id, current_node.depth+1, current_node.x, current_node.y + h, w, h)
        se = Node.new(_get_id, current_node.depth+1, current_node.x + w, current_node.y + h, w, h)

        current_node.nw = nw
        current_node.ne = ne
        current_node.sw = sw
        current_node.se = se

        _add_node(nw)
        _add_node(ne)
        _add_node(sw)
        _add_node(se)

        to_process.each { |child_id| _insert_from(@objects[child_id], current_node) } 
        return _insert_from(object, current_node)
      end

      # If we can't divide it again (we already found the best container), 
      # or we shouldn't because we dont have the max children (shouldnt divide)
      # or are the max level deep (cant divide)
      _add_to_node(object, current_node)
      return current_node
    end
  end

  # Simple incrementing ID
  @current_id = 1_u32
  private def _get_id
    old = @current_id
    @current_id += 1
    return old
  end

  # Inserts an object into this quadtree
  def insert(object : Basic)
    _insert_from(object, @root)
  end

  # Searches the QuadTree for all objects inside the rectangle
  def search(x, y, w, h, &block : Proc(Basic, Nil))
    to_process = [@root] of Node

    while node = to_process.pop?
      @total_checks += 1
      if node.intersects?(x, y, w, h)
        if node.divided?
          to_process << node.nw!
          to_process << node.ne!      
          to_process << node.sw!      
          to_process << node.se!      
        end
        _get_node_children(node).each do |c_id|
          yield @objects[c_id]
        end
      end
    end
  end

  def search(x, y, w, h)
    objects = [] of Basic
    search(x, y, w, h) {|o| objects << o}
    objects
  end

  # This is all pretty bad and I'm not sure where to begin :(
  private struct CheckedPair
    getter o1 : Crixel::ID
    getter o2 : Crixel::ID

    def initialize(@o1, @o2)
    end

    def hash
      o1 + (o2 >> 32)
    end
  end

  private def _check_pair?(o1 : Basic, o2 : Basic) : Bool
    return false if o1 == o2
    b1 = o1.as(IBody).body
    b2 = o2.as(IBody).body
    b1.intersects?(b2)
  end

  def check(&block : Proc(Basic, Basic, Nil))
    checked = Set(CheckedPair).new
    total_matches = 0

    check_proc = ->(o1 : Basic, o2 : Basic) do
      pair1 = CheckedPair.new(o1.id, o2.id)
      pair2 = CheckedPair.new(o2.id, o1.id)
      shouldnt_check = o1 == o2 || checked.includes?(pair1) || checked.includes?(pair2)
      checked << pair1 unless shouldnt_check
      shouldnt_check
    end

    checked_proc = ->(o1 : Basic, o2 : Basic) do
      @total_checks += 1
      total_matches += 1
      _check_pair?(o1, o2)
    end

    @objects.each do |_, o1|
      b1 = o1.as(IBody).body
      
      search(b1.x, b1.y, b1.width, b1.height) do |o2|
        if check_proc.call(o1, o2)
          if checked_proc.call(o1, o2)
            yield(o1, o2)
          end
        end
      end
    end

    total_matches
  end

end