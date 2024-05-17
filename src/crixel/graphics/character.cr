class Crixel::Character < Crixel::Basic
  include IOBB
  include IInvCamera

  @animations = [] of Animation
  property tint : Color = Color::RGBA::WHITE

  def draw
    @animations.each do |anim|
      next if anim.frames.empty? || !anim.playing?
      if (f = anim.current_frame) && f.enabled?
        sin_rotation = Math.sin(rotation)
        cos_rotation = Math.cos(rotation)

        rot_x = f.x + x + dx*cos_rotation - dy*sin_rotation
        rot_y = f.y + y + y + dx*sin_rotation + dy*cos_rotation
        Sprite.draw(Assets.get_texture(f.texture), rot_x, rot_y, f.src_rectangle.width, f.src_rectangle.height, f.rotation + rotation, f.origin, f.src_rectangle, )
      end
    end
  end
end