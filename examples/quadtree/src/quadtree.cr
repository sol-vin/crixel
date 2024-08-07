require "crixel"
require "crixel/audio"
require "crixel/input"
require "crixel/text"
require "crixel/graphics"
require "crixel/collision"

require "crixel/default_rsrc"

Crixel::Assets::BakedFS.bake(path: "rsrc")

class PlayState < Crixel::State
  class Ball < Crixel::Basic
    include Crixel::IBody
    include Crixel::Collidable
    SPEED = 100
    SIZE  =  10

    property velocity : Crixel::Vector2 = Crixel::Vector2.new(0, 0)
    property tint : Crixel::Color = Crixel::Color::WHITE

    def initialize
      @velocity = Crixel::Vector2.new(rand - 1/2, rand - 1/2).normalize
      @collision_mask << :ball
      @width = SIZE.to_f32 + rand(SIZE)
      @height = SIZE.to_f32 + rand(SIZE)

      super
    end

    def update(total_time, elapsed_time)
      @x += @velocity.x * elapsed_time.total_seconds * SPEED
      @y += @velocity.y * elapsed_time.total_seconds * SPEED

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

    def draw(total_time, elapsed_time)
      Crixel::Rectangle.draw(@x, @y, @width, @height, @tint, true)
    end
  end

  MAX_BALLS         = 2_500
  MOUSE_EFFECT_AREA =   500
  PUSH_SPEED        =   200
  @q = Crixel::QuadTree.new(0_f32, 0_f32, Crixel.width.to_f32, Crixel.height.to_f32)
  @items = [] of Ball
  @items_matched : Int32 = 0

  @check_time = Time::Span.new
  @search_time = Time::Span.new
  @insert_time = Time::Span.new

  @insert_timer : Crixel::Timer = Crixel::Timer.new(nanoseconds: 100_000_000)

  def initialize
    super

    # Setup this state
    on_setup do
      @insert_timer.start
      @insert_timer.on_triggered do |t_t, e_t|
        b = Ball.new
        b.position = Crixel::Mouse.uv_position * Crixel::Vector2.new(Crixel.width, Crixel.height)
        @items << b
        add(b)
      end
      MAX_BALLS.times do |i|
        item = Ball.new
        item.x = rand(Crixel.width) - item.width/2
        item.y = rand(Crixel.height) - item.height/2
        add(item)

        @items << item
      end
    end

    # Do stuff before objects are updated
    on_pre_update do |total_time, elapsed_time|
      @items.each { |i| i.tint = Crixel::Color::WHITE }
      if Crixel::Key::Code::E.down?
        @insert_timer.tick(total_time, elapsed_time)
      end
    end

    # Do stuff after the objects are updated
    on_post_update do |total_time, elapsed_time|
      @insert_time = Time.measure do
        @q = Crixel::QuadTree.new(0_f32, 0_f32, Crixel.width.to_f32, Crixel.height.to_f32)

        @items.each { |i| @q.insert i }
        # @q.cleanup
      end

      @check_time = Time.measure do
        @items_matched = @q.check do |c1, c2|
          b1 = c1.as(Ball)
          b2 = c2.as(Ball)

          d = b1.position.distance(b2.position)
          if d < b1.width
            b1.tint = Crixel::Color::BLUE
            b2.tint = Crixel::Color::BLUE
          end
        end
      end

      @search_time = Time.measure do
        if Crixel::Mouse::Button::Code::Left.down? || Crixel::Mouse::Button::Code::Right.down? || Crixel::Mouse::Button::Code::Middle.down?
          uv_mouse = Crixel::Mouse.uv_position
          uv_x = uv_mouse.x - (MOUSE_EFFECT_AREA/Crixel.width)/2
          uv_y = uv_mouse.y - (MOUSE_EFFECT_AREA/Crixel.height)/2

          @q.search(
            uv_x * Crixel.width,
            uv_y * Crixel.height,
            MOUSE_EFFECT_AREA, MOUSE_EFFECT_AREA) do |a|
            i = a.as(Ball)
            m_pos = Crixel::Mouse.uv_position * Crixel::Vector2.new(Crixel.width, Crixel.height)
            if i.center.distance(m_pos) < MOUSE_EFFECT_AREA/2
              i.tint = Crixel::Color::GREEN if Crixel::Mouse::Button::Code::Left.down?
              i.velocity = (i.center - m_pos).normalize if Crixel::Mouse::Button::Code::Right.down?
              if Crixel::Mouse::Button::Code::Middle.down?
                i.destroy
                @items.delete(i)
              end
            end
          end
        end
      end
    end

    # Draw stuff below this state (in the camera)
    on_pre_draw do |total_time, elapsed_time|
    end

    # Draw stuff above this state (in the camera)
    on_post_draw do |total_time, elapsed_time|
      @q.draw(Crixel::Color::RED) if Crixel::Key::Code::Q.down?
    end

    # Draw stuff in the HUD (not in the camera)
    on_draw_hud do |total_time, elapsed_time|
      Raylib.draw_fps(0, 0)
      Crixel::Text.draw("I - #{@insert_time.total_seconds}", Crixel::Vector2.new(0, Crixel.height - 40), tint: Crixel::Color::MAGENTA)
      Crixel::Text.draw("#{@q.total_nodes}<#{@q.total_checks.to_s}<#{@q.total_rectangles} - #{@search_time.total_seconds}", Crixel::Vector2.new(0, Crixel.height - 25), tint: Crixel::Color::RED)

      Crixel::Text.draw("#{@items.size}<#{@items_matched}<#{@items.size**2} - #{@check_time.total_seconds}", Crixel::Vector2.new(0, Crixel.height - 12), tint: Crixel::Color::GREEN)
    end
  end
end

Crixel.start_window(1280, 800) # This must be done here
Crixel.run(PlayState.new)
