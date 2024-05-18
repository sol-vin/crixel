class Crixel::Sprite < Crixel::Basic
  def self.draw_quad(texture_name, src_rectangle, top_left, top_right, bottom_right, bottom_left, tint)
    r_texture = Assets.get_rtexture texture_name
    
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

    # Top-left corner for texture and quad
    if flip_x
      RLGL.texcoord_2f((src_rectangle.x + src_rectangle.width)/r_texture.width, src_rectangle.y/r_texture.height)
    else
      RLGL.texcoord_2f(src_rectangle.x/r_texture.width, src_rectangle.y/r_texture.height)
    end
    RLGL.vertex_2f(top_left.x, top_left.y)

    # Bottom-left corner for texture and quad
    if flip_x
      RLGL.texcoord_2f((src_rectangle.x + src_rectangle.width)/r_texture.width, (src_rectangle.y + src_rectangle.height)/r_texture.height)
    else
      RLGL.texcoord_2f(src_rectangle.x/r_texture.width, (src_rectangle.y + src_rectangle.height)/r_texture.height)
    end
    RLGL.vertex_2f(bottom_left.x, bottom_left.y)

    # Bottom-right corner for texture and quad
    if flip_x
      RLGL.texcoord_2f(src_rectangle.x/r_texture.width, (src_rectangle.y + src_rectangle.height)/r_texture.height)
    else
      RLGL.texcoord_2f((src_rectangle.x + src_rectangle.width)/r_texture.width, (src_rectangle.y + src_rectangle.height)/r_texture.height)
    end
    RLGL.vertex_2f(bottom_right.x, bottom_right.y)

    # Top-right corner for texture and quad
    if flip_x
      RLGL.texcoord_2f(src_rectangle.x/r_texture.width, src_rectangle.y/r_texture.height)
    else
      RLGL.texcoord_2f((src_rectangle.x + src_rectangle.width)/r_texture.width, src_rectangle.y/r_texture.height)
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
    # DrawTexturePro crystalized
    # flip_x = false

    # if src_rectangle.width < 0
    #   flip_x = true
    #   src_rectangle.width *= -1
    # end

    # if src_rectangle.height < 0
    #   src_rectangle.y -= src_rectangle.height
    # end

    # top_left = Vector2.zero
    # top_right = Vector2.zero
    # bottom_right = Vector2.zero
    # bottom_left = Vector2.zero

    # # Only calculate rotation if needed
    # if (rotation.zero?)
    #   x = dest_rectangle.x - origin.x
    #   y = dest_rectangle.y - origin.y
    #   top_left = Vector2.new(x: x, y: y)
    #   top_right = Vector2.new(x: x + dest_rectangle.width, y: y)
    #   bottom_left = Vector2.new(x: x, y: y + dest_rectangle.height)
    #   bottom_right = Vector2.new(x: x + dest_rectangle.width, y: y + dest_rectangle.height)
    # else
    #   sin_rotation = Math.sin(rotation)
    #   cos_rotation = Math.cos(rotation)

    #   x = dest_rectangle.x
    #   y = dest_rectangle.y
    #   dx = -origin.x
    #   dy = -origin.y

    #   top_left = Vector2.zero
    #   top_right = Vector2.zero
    #   bottom_right = Vector2.zero
    #   bottom_left = Vector2.zero

    #   top_left.x = x + dx*cos_rotation - dy*sin_rotation
    #   top_left.y = y + dx*sin_rotation + dy*cos_rotation

    #   top_right.x = x + (dx + dest_rectangle.width)*cos_rotation - dy*sin_rotation
    #   top_right.y = y + (dx + dest_rectangle.width)*sin_rotation + dy*cos_rotation

    #   bottom_left.x = x + dx*cos_rotation - (dy + dest_rectangle.height)*sin_rotation
    #   bottom_left.y = y + dx*sin_rotation + (dy + dest_rectangle.height)*cos_rotation

    #   bottom_right.x = x + (dx + dest_rectangle.width)*cos_rotation - (dy + dest_rectangle.height)*sin_rotation
    #   bottom_right.y = y + (dx + dest_rectangle.width)*sin_rotation + (dy + dest_rectangle.height)*cos_rotation
    # end

    # RLGL.set_texture(r_texture.id)
    # RLGL.begin(RLGL::QUADS)

    # RLGL.color_4ub(tint.r, tint.g, tint.b, tint.a)
    # RLGL.normal_3f(0.0_f32, 0.0_f32, 1.0_f32) # Normal vector pointing towards viewer

    # # Top-left corner for texture and quad
    # if flip_x
    #   RLGL.texcoord_2f((src_rectangle.x + src_rectangle.width)/r_texture.width, src_rectangle.y/r_texture.height)
    # else
    #   RLGL.texcoord_2f(src_rectangle.x/r_texture.width, src_rectangle.y/r_texture.height)
    # end
    # RLGL.vertex_2f(top_left.x, top_left.y)

    # # Bottom-left corner for texture and quad
    # if flip_x
    #   RLGL.texcoord_2f((src_rectangle.x + src_rectangle.width)/r_texture.width, (src_rectangle.y + src_rectangle.height)/r_texture.height)
    # else
    #   RLGL.texcoord_2f(src_rectangle.x/r_texture.width, (src_rectangle.y + src_rectangle.height)/r_texture.height)
    # end
    # RLGL.vertex_2f(bottom_left.x, bottom_left.y)

    # # Bottom-right corner for texture and quad
    # if flip_x
    #   RLGL.texcoord_2f(src_rectangle.x/r_texture.width, (src_rectangle.y + src_rectangle.height)/r_texture.height)
    # else
    #   RLGL.texcoord_2f((src_rectangle.x + src_rectangle.width)/r_texture.width, (src_rectangle.y + src_rectangle.height)/r_texture.height)
    # end
    # RLGL.vertex_2f(bottom_right.x, bottom_right.y)

    # # Top-right corner for texture and quad
    # if flip_x
    #   RLGL.texcoord_2f(src_rectangle.x/r_texture.width, src_rectangle.y/r_texture.height)
    # else
    #   RLGL.texcoord_2f((src_rectangle.x + src_rectangle.width)/r_texture.width, src_rectangle.y/r_texture.height)
    # end
    # RLGL.vertex_2f(top_right.x, top_right.y)

    # RLGL.end
    # RLGL.set_texture(0)
    Raylib.draw_texture_pro(r_texture, src_rectangle.to_raylib, dest_rectangle.to_raylib, origin.to_raylib, rotation, tint.to_raylib)
  end

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
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
    draw_sprite if visible?
  end
end
