require "crixel"
require "crixel/audio"
require "crixel/input"
require "crixel/text"
require "crixel/graphics"

require "crixel/default_rsrc"

Crixel::Assets::BakedFS.bake(path: "rsrc")

class PlayState < Crixel::State
  enum Player
    None
    One
    Two
  end

  BASE_BALL_SPEED = 80.0_f32

  @player1 : Crixel::Sprite = Crixel::Sprite.new("rsrc/paddle.png")
  @player2 : Crixel::Sprite = Crixel::Sprite.new("rsrc/paddle.png")
  @ball : Crixel::Sprite = Crixel::Sprite.new("rsrc/ball.png")
  @ball_direction : Crixel::Vector2 = Crixel::Vector2.zero
  @ball_speed : Float32 = BASE_BALL_SPEED
  @ball_owner : Player = Player::None

  TRAIL_COUNT = 300

  @trails = [] of Tuple(Player, Crixel::Line)

  # @hit_sound : Crixel::Sound = Crixel::Sound.new("rsrc/hit.mp3")
  # @goal_sound : Crixel::Sound = Crixel::Sound.new("rsrc/goal.mp3")

  @player1_score = 0
  @player2_score = 0

  @player1_score_text = Crixel::Text.new("0", text_size: 20)
  @player2_score_text = Crixel::Text.new("0", text_size: 20)

  SPEED = 100

  single_event Score, player : Player

  MIN_ANGLE = 0.25

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

      reset_ball

      @player1_score_text.x = 0
      @player1_score_text.y = 0

      @player2_score_text.x = Crixel.width - @player2_score_text.width
      @player2_score_text.y = 0

      add(@player1)
      add(@player2)

      add(@ball)

      reset_trails

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

      on(Score) do |player|
        if player == Player::One
          @player1_score += 1
          @player1_score_text.text = @player1_score.to_s
        elsif player == Player::Two
          @player2_score += 1
          @player2_score_text.text = @player2_score.to_s
          @player2_score_text.x = Crixel.width - @player2_score_text.width
          @player2_score_text.y = 0
        end

        reset_ball
        reset_trails
      end
    end

    # Do stuff before objects are updated
    on_pre_update do |total_time, elapsed_time|
      @ball.x += @ball_direction.x * @ball_speed * elapsed_time.total_seconds
      @ball.y += @ball_direction.y * @ball_speed * elapsed_time.total_seconds

      if @ball.y < 0 && @ball_direction.y < 0
        @ball_direction.y *= -1
      elsif @ball.bottom > Crixel.height && @ball_direction.y > 0
        @ball_direction.y *= -1
      end

      if @ball.intersects?(@player1) && @ball_owner != Player::One
        @ball_speed *= 1.1_f32
        @ball_direction.x = @ball.x + @ball.width/2 - @player1.x + @player1.width/2
        @ball_direction.y = (@ball.y + @ball.height/2 - @player1.y + @player1.height/2) * -1

        @ball_direction = @ball_direction.normalize
        @ball_direction.x = 1.0_f32 - @ball_direction.x

        @ball_owner = Player::One
        @ball.tint = get_ball_color
      elsif @ball.intersects?(@player2) && @ball_owner != Player::Two
        @ball_speed *= 1.1_f32
        @ball_direction.x = (@player2.x + @player2.width/2 - @ball.x + @ball.width/2) * -1
        @ball_direction.y = @ball.y + @ball.height/2 - @player2.y + @player2.height/2

        @ball_direction = @ball_direction.normalize
        @ball_direction.x = -1.0_f32 - @ball_direction.x

        @ball_owner = Player::Two
        @ball.tint = get_ball_color
      end
    end

    # Do stuff after the objects are updated
    on_post_update do |total_time, elapsed_time|
      if @ball.x + @ball.width > Crixel.width
        emit Score, Player::One
      elsif @ball.x < 0
        emit Score, Player::Two
      end

      @trails.pop
      @trails.unshift({@ball_owner, Crixel::Line.new(@trails[0][1].x2, @trails[0][1].y2, @ball.x + @ball.width/2, @ball.y + @ball.height/2)})
    end

    # Draw stuff below this state (in the camera)
    on_pre_draw do |total_time, elapsed_time|
      @trails.reverse.each_with_index do |item, index|
        owner = item[0]
        line = item[1]
        color = Crixel::Color::WHITE
        if owner == Player::One
          color = Crixel::Color::RED
        elsif owner == Player::Two
          color = Crixel::Color::BLUE
        end

        line.draw(tint: color.fade(index/@trails.size), thickness: 4)
      end
    end

    # Draw stuff above this state (in the camera)
    on_post_draw do |total_time, elapsed_time|
    end

    # Draw stuff in the HUD (not in the camera)
    on_draw_hud do |total_time, elapsed_time|
      @player1_score_text.draw(total_time, elapsed_time)
      @player2_score_text.draw(total_time, elapsed_time)
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

  def reset_ball
    @ball_owner = Player::None
    @ball.tint = get_ball_color
    @ball_direction = Crixel::Vector2.new(x: rand - 0.5, y: (rand - 0.5)/2).normalize
    @ball_speed = BASE_BALL_SPEED
    @ball.x = (Crixel.width/2 - @ball.width/2).to_f32
    @ball.y = (Crixel.height/2 - @ball.height/2).to_f32
  end

  def get_ball_color : Crixel::Color
    case @ball_owner
    when Player::None then Crixel::Color::WHITE
    when Player::One  then Crixel::Color::RED
    when Player::Two  then Crixel::Color::BLUE
    else
      raise("Impossible")
    end
  end

  def reset_trails
    @trails = Array(Tuple(Player, Crixel::Line)).new(TRAIL_COUNT, {@ball_owner, Crixel::Line.new(@ball.x, @ball.y, @ball.x, @ball.y)})
  end
end

Crixel.start_window(400, 300) # This must be done here
Crixel.run(PlayState.new)