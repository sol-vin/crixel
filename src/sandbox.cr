require "./crixel"
require "./crixel/audio"
require "./crixel/input"
require "./crixel/text"
require "./crixel/graphics"

require "./crixel/default_rsrc"

Crixel::Assets::BakedFS.bake(path: "rsrc")

class PlayState < Crixel::State
  enum Player
    None
    One
    Two
  end

  @player1 : Crixel::Sprite = Crixel::Sprite.new("rsrc/paddle.png")
  @player2 : Crixel::Sprite = Crixel::Sprite.new("rsrc/paddle.png")
  # @ball : Crixel::Sprite = Crixel::Sprite.new("rsrc/ball.png")
  # @ball_owner : Player = Player::None

  # @hit_sound : Crixel::Sound = Crixel::Sound.new("rsrc/hit.mp3")
  # @goal_sound : Crixel::Sound = Crixel::Sound.new("rsrc/goal.mp3")

  @player1_score = 0
  @player2_score = 0

  SPEED = 100

  def initialize
    super

    # Setup this state
    on_setup do
      @player1.tint = Crixel::Color::RED
      @player1.x = Crixel.width * 0.1_f32
      @player1.y = Crixel.height * 0.5_f32

      @player2.tint = Crixel::Color::BLUE
      @player2.x = Crixel.width * 0.9_f32 - @player2.width
      @player2.y = Crixel.height * 0.5_f32

      add(@player1)
      add(@player2)

      inputs.get_key(Crixel::Key::Code::W).on_down do |t, e|
        move_up(@player1, e)
      end

      inputs.get_key(Crixel::Key::Code::S).on_down do |t, e|
        move_down(@player1, e)
      end

      inputs.get_key(Crixel::Key::Code::Up).on_down do |t, e|
        move_up(@player2, e)
      end

      inputs.get_key(Crixel::Key::Code::Down).on_down do |t, e|
        move_down(@player2, e)
      end
    end

    # Do stuff before objects are updated
    on_pre_update do |total_time, elapsed_time|
    end

    # Do stuff after the objects are updated
    on_post_update do |total_time, elapsed_time|
    end

    # Draw stuff below this state (in the camera)
    on_pre_draw do |total_time, elapsed_time|
    end

    # Draw stuff above this state (in the camera)
    on_post_draw do |total_time, elapsed_time|
    end

    # Draw stuff in the HUD (not in the camera)
    on_draw_hud do |total_time, elapsed_time|
    end
  end

  def move_up(paddle : Crixel::Sprite, elapsed_time : Time::Span)
    paddle.y -= SPEED * elapsed_time.total_seconds
    paddle.y = 0 if paddle.y < 0
  end

  def move_down(paddle : Crixel::Sprite, elapsed_time : Time::Span)
    paddle.y += SPEED * elapsed_time.total_seconds
    paddle.bottom = Crixel.height if paddle.bottom > Crixel.height
  end
end

Crixel.start_window(400, 300) # This must be done here
Crixel.run(PlayState.new)
