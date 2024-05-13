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

  def initialize
    super

    on_setup do
      # camera.offset = Vector2.new(x: 200, y: 150)
      RAudio.play_sound(Crixel::Assets.get_rsound("default_rsrc/flixel.mp3"))
      @c.zoom = 0.7_f32
      @c.bg_color = Crixel::Color::RGBA::BLACK

      @c.origin = Crixel::Vector2.new(x: @c.width/2, y: @c.height/2)
      @c.on_draw do
        @c.clear_background(Crixel::Color::RGBA::WHITE)
        Crixel::Line.draw(0, 0, @c.width, @c.height, tint: Crixel::Color::RGBA::GREEN)
        Crixel::Line.draw(@c.width, 0, 0, @c.height, tint: Crixel::Color::RGBA::GREEN)
        x = Math.sin(Raylib.get_time).to_f32 * SIN_DISTANCE/2
        y = Math.cos(Raylib.get_time).to_f32 * SIN_DISTANCE/2
        Crixel::Circle.draw(@c.width/2 + x, @c.height/2 + y, 150, Crixel::Color::RGBA::BLUE, fill: true)
        Crixel::Circle.draw(@c.width/2 + x, @c.height/2 + y, 80, Crixel::Color::RGBA::RED, fill: true)
      end

      add(@c)
      view(@c)

      key1 = Crixel.get_key(Crixel::Key::Code::Q)

      key1.on_pressed(name: "q_pressed") do
        puts "Q pressed"
      end

      key1.on_released(name: "q_released") do
        puts "Q released"
      end

      key2 = Crixel.get_key(Crixel::Key::Code::W)
      key2.on_released(name: "w_released") do
        puts "W released"
        key1.remove_released("q_released")
      end

      button = Crixel.get_button(Crixel::Gamepad::Player::One, Crixel::Gamepad::Button::Code::LeftFaceRight)
      button.on_released(name: "dpad_right_released") do
        puts "DPAD Right released"
      end

      button = Crixel.get_mouse_button(Crixel::Mouse::Button::Code::Left)
      button.on_released(name: "left_mouse_released") do
        puts "Left Mouse released"
      end

      trigger = Crixel.get_trigger(Crixel::Gamepad::Player::One, Crixel::Gamepad::Trigger::Code::Left)
      trigger.on_pressed(name: "trigger_pressed") do
        puts "Left Trigger pressed"
      end

      stick = Crixel.get_analog_stick(Crixel::Gamepad::Player::One, Crixel::Gamepad::AnalogStick::Code::Left)
      stick.on_moved(name: "stick_moved") do
        puts "Stick Moved #{stick.current_value.x}, #{stick.current_value.y}"
      end

      4.times { @texts << Crixel::Text.new }
      @texts.each { |t| add(t) }
    end

    on_pre_update do
      @c.rotation = Raylib.get_time.to_f32
      @c.x = Math.sin(Raylib.get_time).to_f32 * SIN_DISTANCE
      @c.y = Math.cos(Raylib.get_time).to_f32 * SIN_DISTANCE

      @c.zoom = 0.4_f32 * Math.sin(Raylib.get_time).to_f32 + 0.7

      ps = @c.points
      @texts.each_with_index do |t, i|
        t.x = ps[i].x
        t.y = ps[i].y
        t.height = 20
        # t.rotation = Raylib.get_time.to_f32
        t.origin = Crixel::Vector2.new(
          x: t.width/2,
          y: t.height/2
        )
        t.rotation = @c.rotation
        t.text = "#{ps[i].x.to_i}, #{ps[i].y.to_i}"
      end
    end

    on_post_draw do
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
