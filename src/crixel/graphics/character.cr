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
    Rectangle.new(x + cf.dst.x , y + cf.dst.y, cf.dst.width, cf.dst.height)
  end

  def current_frame
    current_animation.current_frame
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

      rot = f.dst.position.rotate(self.rotation) + self.position
      dest = Rectangle.new(
        x: rot.x,
        y: rot.y,
        width: f.src.width * scale.x,
        height: f.src.height * scale.y
      )
      dest.draw

      points = IOBB.get_points(dest.x, dest.y, dest.width, dest.height, rotation, origin)
      Sprite.draw_quad(f.texture, f.src, points[0], points[1], points[2], points[3], tint)
      points.each {|n| (n).draw}
    end
  end
end