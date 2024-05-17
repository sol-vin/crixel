class Crixel::Character < Crixel::Basic
  include IPosition
  include IRotation
  include IInvCamera

  @animations = {} of Symbol => Animation
  @current_animation : Symbol? = nil

  property scale : Vector2 = Vector2.one
  property tint : Color = Color::RGBA::WHITE

  def current_animation
    @animations[@current_animation.not_nil!]
  end

  def current_frame_rect
    cf = current_animation.current_frame
    Rectangle.new(x + cf.x , y + cf.y, cf.width, cf.height)
  end

  def add_animation(name : Symbol, anim : Animation)
    @animations[name] = anim
    @current_animation = name if @current_animation.nil?
  end

  def play(name)
    current_animation.stop unless @current_animation.nil?
    @current_animation = name
    current_animation.play
  end

  def update(total_time : Time::Span, elapsed_time : Time::Span)
    if anim_name = @current_animation
      current_animation.advance_time(elapsed_time)
    end
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
    return if @current_animation.nil? || current_animation.frames.empty?
    if (f = current_animation.current_frame) && f.enabled?
      sin_rotation = Math.sin(self.rotation)
      cos_rotation = Math.cos(self.rotation)

      dest = Rectangle.new(
        x + f.x + origin.x,
        y + f.y + origin.y,
        f.width * scale.x,
        f.height * scale.y
      )

      x = dest.x
      y = dest.y
      dx = -origin.x
      dy = -origin.y

      rot_x = x + dx*cos_rotation - dy*sin_rotation
      rot_y = y + dx*sin_rotation + dy*cos_rotation

      dest = Rectangle.new(
        x: rot_x,
        y: rot_y,
        width: f.src_rectangle.width * scale.x,
        height: f.src_rectangle.height * scale.y
      )

      Sprite.draw(f.texture, f.src_rectangle, dest, f.rotation + self.rotation, f.origin, tint)
    end
  end
end