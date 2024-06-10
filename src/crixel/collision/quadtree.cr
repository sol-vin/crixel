require "./leaf"
class Crixel::Quad::Tree < Crixel::Quad::Leaf
  # Hash of objects to the leaf it's inside
  @objects = {} of Crixel::ID => NamedTuple(item: Basic, leaf: Leaf)
  # Hash of leaf nodes to the list of objects contained inside it
  @leafs = {} of Leaf::ID => NamedTuple(leaf: Leaf, items: Set(Basic))

  property max_depth = 5
  property max_children = 5
  getter total_checks = 0

  def initialize(@x, @y, @width, @height)
    @id = 0
  end

  def total_leafs
    @leafs.size
  end

  def total_objects
    @objects.size
  end

  def includes?(child : Basic)
    !!@objects[child.id]?
  end

  def includes?(id : Crixel::ID)
    !!@objects[id]?
  end

  def insert(child : Basic) : Leaf
    raise("Not insertable here (doesnt have a shape)") unless child.is_a?(IBody)
    raise("Not insertable here (is not Collidable)") unless child.is_a?(Collidable)

    if old = @objects[child.id]?
      # Remove from the leaf pool
      _remove_from_leaf(old[:leaf], child)
    end

    current_leaf = _insert(child, self)

    @objects[child.id] = {item: child, leaf: current_leaf}
    return current_leaf
  end

  private def _insert(child : Basic, leaf : Leaf) : Leaf
    current_leaf = leaf.get_container(child.as(IBody))

    # Check if our child count would be over max children
    if @leafs[current_leaf.id]? && (@leafs[current_leaf.id][:items].size + 1) > max_children
      if _subdivide(current_leaf)
        # Trickle old items down into new buckets
        @leafs[current_leaf.id][:items].each do |item|
          new_parent = current_leaf.get_container(item.as(IBody))
          if new_parent != current_leaf
            current_leaf = _insert(child, new_parent)
          end
        end
      end
    end

    _add_to_leaf(current_leaf, child)
    return current_leaf
  end

  # private def _move(child : Basic, from : Leaf, to : Leaf)
  #   @objects[child.id] = {item: child, leaf: to}
  #   _remove_from_leaf(from, child)
  #   _add_to_leaf(to, child)
  # end

  def remove(child : Basic)
    remove(child.id)
  end

  def remove(child_id : Crixel::ID)
    if old = @objects[child_id]?
      _remove_from_leaf(old[:leaf], old[:item])
      @objects.delete(child_id)
    end
  end

  def search(bounds : IBody, &block : Proc(Basic, Nil))
    search(bounds.x, bounds.y, bounds.width, bounds.height, &block)
  end

  def search(bounds : IBody) : Array(Basic)
    search(bounds.x, bounds.y, bounds.width, bounds.height)
  end

  def search(x, y, w, h, &block : Proc(Basic, Nil))
    search_area = Rectangle.new(x, y, w, h)
    get_intersecting(search_area).each do |leaf|
      @leafs[leaf.id][:items].each { |i| yield i }
    end
  end

  def search(x, y, w, h) : Array(Basic)
    output = [] of Basic
    search(x, y, w, h) {|item| output << item}
    output
  end

  private struct CheckedPair
    getter b1 : Crixel::ID
    getter b2 : Crixel::ID

    def initialize(@b1, @b2)
    end

    # def equals?(other : CheckedPair)
    #   (b1 == other.b1 && b2 == other.b2) || 
    #   (b2 == other.b1 && b1 == other.b2)
    # end

    def hash
      b1.to_u64 + (b2.to_u64 >> 32) ^ b2.to_u64 + (b1.to_u64 >> 32)
    end
  end

  def check(&block : Proc(Basic, Basic, Nil))
    @total_checks = 0
    already_checked = Set(CheckedPair).new

    @objects.each do |c_id, object|
      leafs = object[:leaf].get_lineage

      leafs.each do |leaf|
        @leafs[leaf.id][:items].each do |other|
          next if other == object[:item] 
          pair = CheckedPair.new(other.id, object[:item].id)
          next if already_checked.includes?(pair)
          @total_checks += 1

          already_checked << pair
          b1 = other.as(IBody)
          b2 = object[:item].as(IBody)
          yield other, object[:item] if b1.intersects?(b2)
        end
      end
    end
  end

  def draw_grid(no_items_color : Color = Color::RED, items_color : Color = Color::BLUE)
    self.draw(no_items_color)

    @leafs.each do |id, leaf_info|
      leaf_info[:leaf].draw_body(items_color)
    end
  end


  private def _add_to_leaf(leaf : Leaf, child : Basic)
    @leafs[leaf.id] = {leaf: leaf, items: Set(Basic).new} unless @leafs[leaf.id]?
    @leafs[leaf.id][:items] << child
  end
  
  private def _remove_from_leaf(leaf : Leaf, child : Basic)
    _remove_from_leaf(leaf.id, child.id)
  end

  private def _remove_from_leaf(leaf : Leaf, child_id : Crixel::ID)
    _remove_from_leaf(leaf.id, child_id)
  end
  
  private def _remove_from_leaf(leaf_id : Leaf::ID, child : Basic)
    _remove_from_leaf(leaf_id, child.id)
  end

  private def _remove_from_leaf(leaf_id : Leaf::ID, child_id : Crixel::ID)
    @leafs[leaf_id][:items].delete(child_id)

    if @leafs[leaf_id][:items].empty?
      puts "Deleting leaf #{leaf_id}"
      @leafs.delete leaf_id
    end
  end

  private def _subdivide(leaf : Leaf) : Bool
    return false if leaf.current_depth >= max_depth
    leaf.divided = true
    w = leaf.width/2
    h = leaf.height/2
    leaf.nw = Leaf.new(leaf, get_id, x, y, w, h)
    leaf.ne = Leaf.new(leaf, get_id, x + w, y, w, h)
    leaf.sw = Leaf.new(leaf, get_id, x, y + h, w, h)
    leaf.se = Leaf.new(leaf, get_id, x + w, y + h, w, h)
    return true
  end

  @current_id = 1_u32
  private def get_id
    old = @current_id
    @current_id += 1
    return old
  end
end