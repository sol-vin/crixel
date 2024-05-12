module Crixel::ISprite
  include IOBB

  # TODO: Make a new texture class to hold this kind of info
  property texture : String = "default_rsrc/logo.png"
  setter src_rectangle : Rectangle? = nil
  property tint : Color::RGBA = Color::RGBA.new(r: 0xFF, b: 0xFF, g: 0xFF, a: 0xFF)

  def src_rectangle : Rectangle
    raylib_texture = Assets.get_texture(texture)
    @src_rectangle ? @src_rectangle.not_nil! : Rectangle.new(x: 0, y: 0, width: raylib_texture.width, height: raylib_texture.height)
  end

  def draw_sprite
    r_texture = Assets.get_texture(texture)
    raise "Cannot open texture" unless Raylib.texture_ready? r_texture

    flip_x = false

    source = src_rectangle

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
      dst_rectangle.x + origin.x,
      dst_rectangle.y + origin.y,
      dst_rectangle.width,
      dst_rectangle.height
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
      points = self.points
      top_left = points[0]
      top_right = points[1]
      bottom_left = points[3]
      bottom_right = points[2]
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
end
