require "./crixel"
require "./crixel/audio"
require "./crixel/input"

Crixel.start_window(400, 300) # This must be done here
Crixel.install_default_assets

class PlayState < Crixel::State
  SIN_DISTANCE = 150

  @texture = Raylib::Texture2D.new

  @c : Crixel::RenderTarget = Crixel::RenderTarget.new("my_render", width: 400, height: 300)

  @texts : Array(Crixel::Text) = [] of Crixel::Text

  @total_time = Time::Span.new

  def initialize
    super

    on_setup do
      # camera.offset = Vector2.new(x: 200, y: 150)
      RAudio.play_sound(Crixel::Assets.get_rsound("default_rsrc/flixel.mp3"))
      @c.zoom = 0.7_f32
      @c.bg_color = Crixel::Color::RGBA::BLACK

      @c.origin = Crixel::Vector2.new(x: @c.width/2, y: @c.height/2)
      @c.on_draw do |elapsed_time|
        @total_time += elapsed_time
        @c.clear_background(Crixel::Color::RGBA::WHITE)
        Crixel::Line.draw(0, 0, @c.width, @c.height, tint: Crixel::Color::RGBA::GREEN)
        Crixel::Line.draw(@c.width, 0, 0, @c.height, tint: Crixel::Color::RGBA::GREEN)
        x = Math.sin(@total_time.total_seconds).to_f32 * SIN_DISTANCE/2
        y = Math.cos(@total_time.total_seconds).to_f32 * SIN_DISTANCE/2
        Crixel::Circle.draw(@c.width/2 + x, @c.height/2 + y, 150, Crixel::Color::RGBA::BLUE, fill: true)
        Crixel::Circle.draw(@c.width/2 + x, @c.height/2 + y, 75, Crixel::Color::RGBA::RED, fill: true)
      end

      add(@c)
      view(@c)

      key1 = inputs.get_key(Crixel::Key::Code::Q)

      key1.on_pressed(name: "q_pressed") do
        puts "Q pressed"
      end

      4.times { @texts << Crixel::Text.new }
      @texts.each { |t| t.tint = Crixel::Color::RGBA::GREEN; add(t) }
    end

    on_pre_update do |elapsed_time|
      @c.rotation = Crixel.total_time.total_seconds.to_f32
      @c.x = Math.sin(Crixel.total_time.total_seconds).to_f32 * SIN_DISTANCE
      @c.y = Math.cos(Crixel.total_time.total_seconds).to_f32 * SIN_DISTANCE

      @c.zoom = 0.4_f32 * Math.sin(Crixel.total_time.total_seconds).to_f32 + 0.7

      ps = @c.points
      @texts.each_with_index do |t, i|
        t.x = ps[i].x
        t.y = ps[i].y
        t.height = 20
        t.origin = Crixel::Vector2.new(
          x: t.width/2,
          y: t.height/2
        )
        t.rotation = @c.rotation
        t.text = "#{ps[i].x.to_i}, #{ps[i].y.to_i}"
      end
    end

    on_post_draw do |elapsed_time|
      @c.src_rectangle.draw(Crixel::Color::RGBA.new(r: 255, a: 255))
      @c.dst_rectangle.draw(Crixel::Color::RGBA.new(b: 255, a: 255))
      @c.draw_area_bounding_box(Crixel::Color::RGBA.new(g: 255, a: 255))
      @c.draw_obb(Crixel::Color::RGBA.new(r: 255, g: 255, a: 255))
      @c.draw_rotation(tint: Crixel::Color::RGBA.new(r: 255, b: 255, a: 255))
      Crixel::Circle.draw(@c.x, @c.y, SIN_DISTANCE, Crixel::Color::RGBA::RED)
    end
  end
end

Crixel.run(PlayState.new)
