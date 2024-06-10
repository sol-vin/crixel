require "./leaf"
class Crixel::Quad::Tree < Crixel::Quad::Leaf
  class Item
    property object : Basic
    property leaf : Leaf

    def initialize(@basic, @leaf)
  end

  include IBody

  # Hash of objects to the leaf it's inside
  @items = {} of Crixel::ID => Item
  @leafs = {} of Leaf::ID => Set(Crixel::ID)

  property max_depth = 5
  property max_children = 5
  getter total_checks = 0

  def initialize(@x, @y, @width, @height)
    @id = 0
  end

  def total_items
    @items.size
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

  def insert(child : Basic) : Leaf
    raise("Not insertable here (doesnt have a shape)") unless child.is_a?(IBody)
    raise("Not insertable here (is not Collidable)") unless child.is_a?(Collidable)

    if self.includes?(child)
      self.remove(child)
    end

    current_leaf = self

    if current_leaf.divided?
    else
    end
  end
  
  def remove(child : Basic)
    if old = get_item?(child)
      @leafs[old.leaf.id].delete(child.id)
      @items.delete child.id
    end
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
  end

  def check(&block : Proc(Basic, Basic, Nil))
  end

  def draw_grid(no_items_color : Color = Color::RED, items_color : Color = Color::BLUE)
    self.draw(no_items_color)

    @leafs.each do |leaf, children|
      leaf.draw_body(items_color)
    end
  end

  def cleanup
  end

  private def _subdivide(leaf : Leaf)
    leaf.divide(get_id, get_id, get_id, get_id)
  end

  @current_id = 1_u32
  private def get_id
    old = @current_id
    @current_id += 1
    return old
  end
end