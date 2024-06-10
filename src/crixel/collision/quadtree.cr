class Crixel::Quad::Tree
  class Item
    property object : Basic
    property leaf : Leaf

    def initialize(@object, @leaf)
    end
  end

  class LeafItem
    property leaf : Leaf
    property children : Set(Crixel::ID) = Set(Crixel::ID).new

    def initialize(@leaf)
    end
  end

  class Leaf
    include IBody

    alias ID = UInt32
    getter id : ID
    getter? divided = false

    getter parent : Leaf?
    getter nw : Leaf?
    getter ne : Leaf?
    getter sw : Leaf?
    getter se : Leaf?

    getter depth : Int32

    def initialize(@id, @parent, @x, @y, @width, @height)
      @depth = parent ? parent.depth + 1 : 0
    end

    def root?
      @parent.nil?
    end

    def divide(nw_id, ne_id, sw_id, se_id)
      return if divided?
      @divided = true
      w = width/2
      h = height/2
      @nw = Leaf.new(nw_id, self, x, y, w, h)
      @ne = Leaf.new(ne_id, self, x + w, y, w, h)
      @sw = Leaf.new(sw_id, self, x, y + h, w, h)
      @se = Leaf.new(se_id, self, x + w, y + h, w, h)
    end

    def merge
      @divided = false
      @nw = nil
      @ne = nil
      @sw = nil
      @se = nil
    end

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

    def all : StaticArray(Leaf, 4)
      StaticArray[nw!, ne!, sw!, se!]
    end

    def get_container(bounds : IBody) : Leaf
      if divided?
        p_container = all.find do |region|
          region.contains?(bounds) 
        end

        if container = p_container
          return container.get_container(bounds)
        end
      end
      return self
    end

    def each_intersecting(bounds : IBody, &block : Proc(Leaf, Nil))
      return unless self.intersects?(bounds)
      if divided?
        nw!.each_intersecting(bounds) {|leaf| block.call(leaf)}
        ne!.each_intersecting(bounds) {|leaf| block.call(leaf)}
        sw!.each_intersecting(bounds) {|leaf| block.call(leaf)}
        se!.each_intersecting(bounds) {|leaf| block.call(leaf)}
      end
      return self
    end

    def each_parent(&block : Proc(Leaf, Nil))
      current = @parent

      while c = current
        yield c
        current = c.parent
      end
    end

    def draw(color : Color = Color::RED)
      self.draw_body(color)
      if divided?
        nw!.draw(color)
        ne!.draw(color)
        sw!.draw(color)
        se!.draw(color)
      end
    end

    def equals?(other : Leaf)
      self.id == other.id
    end
  end

  include IBody

  # Hash of objects to the leaf it's inside
  @items = {} of Crixel::ID => Item
  @leafs = {} of Leaf::ID => LeafItem

  @root : Leaf

  property max_depth = 5
  property max_children = 5
  getter total_checks = 0

  def initialize(@x, @y, @width, @height)
    @root = Leaf.new(get_id, nil, @x, @y, @width, @height)
  end

  def total_items
    @items.size
  end

  def total_leafs
    @leafs.size
  end

  def includes?(child : Basic)
    !!@items[child.id]?
  end

  def includes?(id : Crixel::ID)
    !!@items[id]?
  end

  def get_item(id : Crixel::ID)
    @items[id]
  end

  def get_item?(id : Crixel::ID)
    @items[id]?
  end

  def get_leaf_children(leaf : Leaf) : Set(Crixel::ID)
    get_leaf_children(leaf.id)
  end

  def get_leaf_children(leaf_id : Leaf::ID) : Set(Crixel::ID)
    @leafs[leaf_id]? ? @leafs[leaf_id].children : Set(Crixel::ID).new
  end

  private def _add_to_leaf(child : Basic, leaf : Leaf)
    @items[child.id] = Item.new(child, leaf)
    @leafs[leaf.id] = LeafItem.new(leaf) unless @leafs[leaf.id]?
    @leafs[leaf.id].children << child.id
  end

  private def _remove_from_leaf(child : Basic, leaf : Leaf)
    @leafs[leaf.id].children.delete(child.id)

    # @leafs.delete(leaf.id) if @leafs[leaf.id].children.empty?
  end

  private def _remove_from_leaf(child_id : Crixel::ID, leaf : Leaf)
    @leafs[leaf.id].children.delete(child_id)

    # @leafs.delete(leaf.id) if @leafs[leaf.id].children.empty?
  end

  private def _leaf_has_children?(leaf_id : Leaf::ID)
    !!@leafs[leaf_id]?
  end

  private def _leaf_has_children?(leaf : Leaf)
    _leaf_has_children?(leaf.id)
  end

  private def _leaf_child_count(leaf : Leaf)
    @leafs[leaf.id]? ? @leafs[leaf.id].children.size : 0
  end

  private def _merge_leaf?(leaf : Leaf)
    total_children = 0
    can_merge = leaf.all.all? {|l| total_children += _leaf_child_count(l); !l.divided? }
    can_merge && total_children < max_children
  end

  private def _delete_leaf?(leaf : Leaf)
    total_children = 0
    can_merge = leaf.all.all? {|l| total_children += _leaf_child_count(l); !l.divided? }
    can_merge && total_children == 0
  end

  def remove(child)
    old_leaf = @items[child.id].leaf

    _remove_from_leaf(child, old_leaf)
  end

  def insert(child : Basic)
    raise("Not insertable here (doesnt have a shape)") unless child.is_a?(IBody)
    raise("Not insertable here (is not Collidable)") unless child.is_a?(Collidable)

    _insert_from(child, @root)
  end

  private def _insert_from(child : Basic, leaf : Leaf)
    current_leaf = leaf
    
    if current_leaf.divided?
      current_leaf = current_leaf.get_container(child.as(IBody))
    end
    
    _add_to_leaf(child, current_leaf)
    
    if !current_leaf.divided? && current_leaf.depth < max_depth && _leaf_child_count(current_leaf) > max_children
      children = get_leaf_children(current_leaf)
      _subdivide(current_leaf)
      children.each do |c|
        item = get_item(c).object
        _remove_from_leaf(item, current_leaf)
        _insert_from(item, current_leaf)
      end
    end
  end

  private def _subdivide(leaf : Leaf)
    leaf.divide(get_id, get_id, get_id, get_id)
    @leafs[leaf.id].children = Set(Crixel::ID).new
  end

  def search(bounds : IBody, &block : Proc(Basic, Nil))
    search(bounds.x, bounds.y, bounds.width, bounds.height, &block)
  end

  def search(bounds : IBody) : Array(Basic)
    search(bounds.x, bounds.y, bounds.width, bounds.height)
  end

  def search(x, y, w, h) : Array(Basic)
    output = [] of Basic
    search(x, y, w, h) {|item| output << item}
    output
  end

  def search(x, y, w, h, &block : Proc(Basic, Nil))
    search_area = Rectangle.new(x, y, w, h)
    @root.each_intersecting(search_area) do |leaf|
      @leafs[leaf.id].children.each { |i| block.call(get_item(i).object) }
    end
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

    @items.each do |c_id, info|
      info.leaf.each_parent do |parent|
        @leafs[parent].children.each do |other|
          next if other == c_id
          pair = CheckedPair.new(other, c_id)
          next if already_checked.includes?(pair)
          @total_checks += 1

          already_checked << pair
          b1 = get_item(other).object.as(IBody)
          b2 = info.object.as(IBody)
          yield get_item(other).object, info.object if b1.intersects?(b2)
        end
      end
    end
  end

  def draw_grid(no_items_color : Color = Color::RED, has_items_color : Color = Color::BLUE, item_color : Color = Color::GREEN)
    @root.draw(no_items_color)

    @leafs.each do |leaf_id, info|
      info.leaf.draw_body(has_items_color)
    end

    @items.each do |c_id, item|
      item.object.as(IBody).draw_body(item_color)
    end
  end

  def cleanup
    dead_leafs = [] of Leaf
    @leafs = @leafs.reject do |id, info|
      empty = !info.leaf.divided? && info.children.empty?
      dead_leafs << info.leaf if empty
      empty
    end

    
  end

  @current_id = 0_u32
  private def get_id
    old = @current_id
    @current_id += 1
    return old
  end
end