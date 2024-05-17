class Crixel::Character < Crixel::Basic
  include IOBB
  include IInvCamera

  @animations = {} of Symbol => Animation
  @current_animation : Symbol? = nil
  property tint : Color = Color::RGBA::WHITE

  def current_animation
    @animations[@current_animation.not_nil!]
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

      rot_x = f.x + self.x + origin.x*cos_rotation - origin.y*sin_rotation
      rot_y = f.y + self.y + origin.x*sin_rotation + origin.y*cos_rotation
      Sprite.draw(Assets.get_texture(f.texture), rot_x, rot_y, f.src_rectangle.width, f.src_rectangle.height, f.rotation + self.rotation, f.origin, f.src_rectangle, tint)
    end
  end
end