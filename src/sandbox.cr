require "./crixel"
require "./crixel/audio"

class PlayState < Crixel::State
  @texture = Raylib::Texture2D.new

  @c : Crixel::Sprite? = nil

  def setup
    # camera.offset = Raylib::Vector2.new(x: 200, y: 150)
    RAudio.play_sound(Crixel::Assets.get_sound("default_rsrc/flixel.mp3"))
    camera.zoom = 0.7_f32
    camera.offset.x = 200
    camera.offset.y = 150

    @c = Crixel::Sprite.new(width: 400, height: 300)
    @c.not_nil!.origin = Raylib::Vector2.new(x: @c.not_nil!.width/2, y: @c.not_nil!.height/2)
    add(@c.not_nil!)

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
  end

  def pre_update
    @c.not_nil!.rotation = (Raylib.get_time).to_f32
    # trigger = Crixel::Gamepad::Triggers.get(Crixel::Gamepad::Player::One, Crixel::Gamepad::Trigger::Code::Left)
    # puts trigger.current_value
  end
end

Crixel::Assets::BakedFS.bake(path: "rsrc")

# on Crixel::Assets::Setup do
#   Crixel::Assets.load_from_path("rsrc/wire.png")
# end

Crixel.run(400, 300, PlayState.new)

# # puts 0.0_f32.zero?
