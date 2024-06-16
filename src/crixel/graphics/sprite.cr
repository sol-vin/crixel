class Crixel::Sprite < Crixel::Basic
  def self.draw_quad(texture_name : String, src_rectangle, top_left, top_right, bottom_right, bottom_left, tint)
    self.draw_quad(Assets.get_rtexture(texture_name), src_rectangle, top_left, top_right, bottom_right, bottom_left, tint)
  end

  def self.draw_quad(r_texture : Raylib::Texture2D, src_rectangle, top_left, top_right, bottom_right, bottom_left, tint)
    flip_x = false

    if src_rectangle.width < 0
      flip_x = true
      src_rectangle.width *= -1
    end

    if src_rectangle.height < 0
      src_rectangle.y -= src_rectangle.height
    end

    RLGL.set_texture(r_texture.id)
    RLGL.begin(RLGL::QUADS)

    RLGL.color_4ub(tint.r, tint.g, tint.b, tint.a)
    RLGL.normal_3f(0.0_f32, 0.0_f32, 1.0_f32) # Normal vector pointing towards viewer

    src_x = src_rectangle.x.to_i
    src_y = src_rectangle.y.to_i
    src_width = src_rectangle.width.to_i
    src_height = src_rectangle.height.to_i

    # Top-left corner for texture and quad
    if flip_x
      RLGL.texcoord_2f((src_x + src_width)/r_texture.width, src_y/r_texture.height)
    else
      RLGL.texcoord_2f(src_x/r_texture.width, src_y/r_texture.height)
    end
    RLGL.vertex_2f(top_left.x, top_left.y)

    # Bottom-left corner for texture and quad
    if flip_x
      RLGL.texcoord_2f((src_x + src_width)/r_texture.width, (src_y + src_height)/r_texture.height)
    else
      RLGL.texcoord_2f(src_rectangle.x/r_texture.width, (src_y + src_height)/r_texture.height)
    end
    RLGL.vertex_2f(bottom_left.x, bottom_left.y)

    # Bottom-right corner for texture and quad
    if flip_x
      RLGL.texcoord_2f(src_x/r_texture.width, (src_y + src_height)/r_texture.height)
    else
      RLGL.texcoord_2f((src_x + src_width)/r_texture.width, (src_y + src_height)/r_texture.height)
    end
    RLGL.vertex_2f(bottom_right.x, bottom_right.y)

    # Top-right corner for texture and quad
    if flip_x
      RLGL.texcoord_2f(src_x/r_texture.width, src_y/r_texture.height)
    else
      RLGL.texcoord_2f((src_x + src_width)/r_texture.width, src_y/r_texture.height)
    end
    RLGL.vertex_2f(top_right.x, top_right.y)

    RLGL.end
    RLGL.set_texture(0)
  end

  def self.draw(
    texture_name : String,
    src_rectangle : Rectangle,
    dest_rectangle : Rectangle,
    rotation : Number = 0.0_f32,
    origin : Vector2 = Vector2.zero,
    tint : Color = Color::RGBA::WHITE
  )
    r_texture = Assets.get_rtexture texture_name
    points = IOBB.get_points(dest_rectangle, rotation, origin)
    Sprite.draw_quad(r_texture, src_rectangle, points[0], points[1], points[2], points[3], tint)
    # Raylib.draw_texture_pro(r_texture, src_rectangle.to_raylib, dest_rectangle.to_raylib, origin.to_raylib, rotation, tint.to_raylib)
  end

  include IOBB
  include ISprite
  include IInvCamera

  def initialize(
    @texture = "default_rsrc/logo.png",
    x = 0.0_f32,
    y = 0.0_f32,
    width = nil,
    height = nil,
    src_rectangle : Rectangle? = nil
  )
    r_texture = Crixel::Assets.get_rtexture(@texture)
    @width = (width || r_texture.width).to_f32
    @height = (height || r_texture.height).to_f32
    if src = src_rectangle
      self.src_rectangle = src
    else
      self.src_rectangle = Rectangle.new(width: r_texture.width, height: r_texture.height)
    end

    super()
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
    Sprite.draw(@texture, @src_rectangle, to_rectangle, rotation, origin, tint)
  end
end
