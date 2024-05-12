require "./crixel"
require "./crixel/audio"

class PlayState < Crixel::State
  @texture = Raylib::Texture2D.new

  @c : Crixel::Sprite = Crixel::Sprite.new(width: 400, height: 300)

  @texts : Array(Crixel::Text) = [] of Crixel::Text

  def setup
    # camera.offset = Vector2.new(x: 200, y: 150)
    RAudio.play_sound(Crixel::Assets.get_sound("default_rsrc/flixel.mp3"))
    camera.zoom = 0.7_f32
    camera.offset.x = 200
    camera.offset.y = 150

    @c.origin = Crixel::Vector2.new(x: @c.width/2, y: @c.height/2)
    add(@c)

    key1 = Crixel::Keys.get(Crixel::Key::Code::Q)

    key1.on_pressed(name: "q_pressed") do
      puts "Q pressed"
    end

    key1.on_released(name: "q_released") do
      puts "Q released"
    end

    key2 = Crixel::Keys.get(Crixel::Key::Code::W)
    key2.on_released(name: "w_released") do
      puts "W released"
      key1.delete_released("q_released")
    end

    button = Crixel::Gamepad::Buttons.get(Crixel::Gamepad::Player::One, Crixel::Gamepad::Button::Code::LeftFaceRight)
    button.on_released(name: "dpad_right_released") do
      puts "DPAD Right released"
    end

    button = Crixel::Mouse::Buttons.get(Crixel::Mouse::Button::Code::Left)
    button.on_released(name: "left_mouse_released") do
      puts "Left Mouse released"
    end

    trigger = Crixel::Gamepad::Triggers.get(Crixel::Gamepad::Player::One, Crixel::Gamepad::Trigger::Code::Left)
    trigger.on_pressed(name: "trigger_pressed") do
      puts "Left Trigger pressed"
    end

    stick = Crixel::Gamepad::AnalogSticks.get(Crixel::Gamepad::Player::One, Crixel::Gamepad::AnalogStick::Code::Left)
    stick.on_moved(name: "stick_moved") do
      puts "Stick Moved #{stick.current_value.x}, #{stick.current_value.y}"
    end

    4.times { @texts << Crixel::Text.new }
    @texts.each { |t| add(t) }
  end

  def pre_update
    @c.rotation = Raylib.get_time.to_f32

    # Camera has to spin the opposite way
    # camera.rotation = -Raylib.get_time.to_f32

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
      t.text = "#{ps[i].x.to_i}, #{ps[i].y.to_i}"
    end
  end

  def post_draw
    @c.src_rectangle.draw(Crixel::Color::RGBA.new(r: 255, a: 255))
    @c.dst_rectangle.draw(Crixel::Color::RGBA.new(b: 255, a: 255))
    @c.draw_area_bounding_box(Crixel::Color::RGBA.new(g: 255, a: 255))
    @c.draw_obb(Crixel::Color::RGBA.new(r: 255, g: 255, a: 255))
  end
end

Crixel.run(400, 300, PlayState.new)
