require "./leaf"
class Crixel::Quad::Tree < Crixel::Quad::Leaf
  class Item
    property object : Basic
    property leaf : Leaf

    def initialize(@basic, @leaf)
  end

  # Hash of objects to the leaf it's inside
  @items = {} of Crixel::ID => Item

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

  def insert(child : Basic) : Leaf
    raise("Not insertable here (doesnt have a shape)") unless child.is_a?(IBody)
    raise("Not insertable here (is not Collidable)") unless child.is_a?(Collidable)

    
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

    @leafs.each do |id, leaf_info|
      leaf_info[:leaf].draw_body(items_color)
    end
  end
end