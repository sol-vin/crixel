require "./crixel"
require "./crixel/audio"
require "./crixel/input"
require "./crixel/text"
require "./crixel/graphics"
require "./crixel/collision"

require "./crixel/default_rsrc"

Crixel::Assets::BakedFS.bake(path: "rsrc")

class PlayState < Crixel::State
  class Ball < Crixel::Sprite
    @velocity : Crixel::Vector2 = Crixel::Vector2.new(0, 0)

    def initialize
      @velocity = Crixel::Vector2.new(rand(10)-5, rand(10)-5)
      super("rsrc/ball.png", width: 1, height: 1)
    end

    def update(total_time, elapsed_time)
      @x += @velocity.x * elapsed_time.total_seconds
      @y += @velocity.y * elapsed_time.total_seconds

      if self.left < 0 && @velocity.x < 0
        @velocity.x *= -1
        self.left = 0
      elsif self.right > Crixel.width && @velocity.x > 0
        @velocity.x *= -1
        self.right = Crixel.width
      end

      if self.top < 0 && @velocity.y < 0
        @velocity.y *= -1
        self.top = 0
      elsif self.bottom > Crixel.height && @velocity.y > 0
        @velocity.y *= -1
        self.bottom = Crixel.height
      end
    end
  end
  @q = Crixel::QuadTree.new
  @items = [] of Crixel::Sprite

  def initialize
    super

    # Setup this state
    on_setup do
      1000.times do |i|
        item = Ball.new
        item.x = rand(Crixel.width) - item.width/2
        item.y = rand(Crixel.height) - item.height/2
        add(item)

        @items << item
      end
    end

    # Do stuff before objects are updated
    on_pre_update do |total_time, elapsed_time|
    end

    # Do stuff after the objects are updated
    on_post_update do |total_time, elapsed_time|
      @q = Crixel::QuadTree.new
      @q.x = 0
      @q.y = 0
      @q.width = Crixel.width.to_f32
      @q.height = Crixel.height.to_f32

      @items.each {|i| @q.insert i}
    end

    # Draw stuff below this state (in the camera)
    on_pre_draw do |total_time, elapsed_time|
    end

    # Draw stuff above this state (in the camera)
    on_post_draw do |total_time, elapsed_time|
      @q.draw(Crixel::Color::RED)
    end

    # Draw stuff in the HUD (not in the camera)
    on_draw_hud do |total_time, elapsed_time|
    end
  end
end

Crixel.start_window(400, 300) # This must be done here
Crixel.run(PlayState.new)
