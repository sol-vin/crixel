class Crixel::Sprite < Crixel::Basic
  def self.draw(
    texture_name : String,
    x, y, width, height,
    rotation : Number = 0.0_f32, origin : Vector2 = Vector2.zero,
    src_rectangle : Rectangle? = nil,
    tint : Color = Color::RGBA::WHITE
  )
    draw(Assets.get_texture(texture_name).rtexture, x, y, Vector2.new(width, height), rotation, origin, src_rectangle, tint)
  end

  def self.draw(
    texture : Assets::Texture,
    x, y, width, height,
    rotation : Number = 0.0_f32, origin : Vector2 = Vector2.zero,
    src_rectangle : Rectangle? = nil,
    tint : Color = Color::RGBA::WHITE
  )
    draw(texture.rtexture, x, y, Vector2.new(width, height), rotation, origin, src_rectangle, tint)
  end

  def self.draw(
    texture : Assets::Texture,
    x, y, size : Vector2? = nil,
    rotation : Number = 0.0_f32, origin : Vector2 = Vector2.zero,
    src_rectangle : Rectangle? = nil,
    tint : Color = Color::RGBA::WHITE
  )
    r_texture = texture.rtexture
    raise "Cannot open texture" unless Raylib.texture_ready? r_texture
    draw()
  end

  def self.draw(
    r_texture : Raylib::Texture2D,
    x, y, size : Vector2? = nil,
    rotation : Number = 0.0_f32, origin : Vector2 = Vector2.zero,
    src_rectangle : Rectangle? = nil,
    tint : Color = Color::RGBA::WHITE
  )
    flip_x = false

    source = Rectangle.new
    if src_rectangle
      source = src_rectangle
    else
      source = Rectangle.new(0, 0, r_texture.width, r_texture.height)
    end

    if source.width < 0
      flip_x = true
      source.width *= -1
    end

    if source.height < 0
      source.y -= source.height
    end

    top_left = Vector2.zero
    top_right = Vector2.zero
    bottom_right = Vector2.zero
    bottom_left = Vector2.zero

    dest = Rectangle.new(
      x,
      y,
      (size ? size.not_nil!.x : r_texture.width),
      (size ? size.not_nil!.y : r_texture.height),
    )

    # Only calculate rotation if needed
    if (rotation.zero?)
      x = dest.x - origin.x
      y = dest.y - origin.y
      top_left = Vector2.new(x: x, y: y)
      top_right = Vector2.new(x: x + dest.width, y: y)
      bottom_left = Vector2.new(x: x, y: y + dest.height)
      bottom_right = Vector2.new(x: x + dest.width, y: y + dest.height)
    else
      sin_rotation = Math.sin(rotation)
      cos_rotation = Math.cos(rotation)

      x = dest.x
      y = dest.y
      dx = -origin.x
      dy = -origin.y

      top_left = Vector2.zero
      top_right = Vector2.zero
      bottom_right = Vector2.zero
      bottom_left = Vector2.zero

      top_left.x = x + dx*cos_rotation - dy*sin_rotation
      top_left.y = y + dx*sin_rotation + dy*cos_rotation

      top_right.x = x + (dx + dest.width)*cos_rotation - dy*sin_rotation
      top_right.y = y + (dx + dest.width)*sin_rotation + dy*cos_rotation

      bottom_left.x = x + dx*cos_rotation - (dy + dest.height)*sin_rotation
      bottom_left.y = y + dx*sin_rotation + (dy + dest.height)*cos_rotation

      bottom_right.x = x + (dx + dest.width)*cos_rotation - (dy + dest.height)*sin_rotation
      bottom_right.y = y + (dx + dest.width)*sin_rotation + (dy + dest.height)*cos_rotation
    end

    RLGL.set_texture(r_texture.id)
    RLGL.begin(RLGL::QUADS)

    RLGL.color_4ub(tint.r, tint.g, tint.b, tint.a)
    RLGL.normal_3f(0.0_f32, 0.0_f32, 1.0_f32) # Normal vector pointing towards viewer

    # Top-left corner for texture and quad
    if flip_x
      RLGL.texcoord_2f((source.x + source.width)/r_texture.width, source.y/r_texture.height)
    else
      RLGL.texcoord_2f(source.x/r_texture.width, source.y/r_texture.height)
    end
    RLGL.vertex_2f(top_left.x, top_left.y)

    # Bottom-left corner for texture and quad
    if flip_x
      RLGL.texcoord_2f((source.x + source.width)/r_texture.width, (source.y + source.height)/r_texture.height)
    else
      RLGL.texcoord_2f(source.x/r_texture.width, (source.y + source.height)/r_texture.height)
    end
    RLGL.vertex_2f(bottom_left.x, bottom_left.y)

    # Bottom-right corner for texture and quad
    if flip_x
      RLGL.texcoord_2f(source.x/r_texture.width, (source.y + source.height)/r_texture.height)
    else
      RLGL.texcoord_2f((source.x + source.width)/r_texture.width, (source.y + source.height)/r_texture.height)
    end
    RLGL.vertex_2f(bottom_right.x, bottom_right.y)

    # Top-right corner for texture and quad
    if flip_x
      RLGL.texcoord_2f(source.x/r_texture.width, source.y/r_texture.height)
    else
      RLGL.texcoord_2f((source.x + source.width)/r_texture.width, source.y/r_texture.height)
    end
    RLGL.vertex_2f(top_right.x, top_right.y)

    RLGL.end
    RLGL.set_texture(0)
  end

  include ISprite
  include IInvCamera

  def initialize(
    @texture = "default_rsrc/logo.png",
    x = 0.0_f32,
    y = 0.0_f32,
    width = nil,
    height = nil
  )
    r_texture = Crixel::Assets.get_rtexture(@texture)
    @width = (width || r_texture.width).to_f32
    @height = (height || r_texture.height).to_f32
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
    draw_sprite if visible?
  end
end
