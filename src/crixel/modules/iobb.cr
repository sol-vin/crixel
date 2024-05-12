require "./iposition"
require "./isize"
require "./irotation"

module Crixel::IOBB
  include IPosition
  include ISize
  include IRotation

  property offset : Vector2 = Vector2.zero

  def points : StaticArray(Vector2, 4)
    points = StaticArray(Vector2, 4).new(Vector2.zero)
    sin_rotation = Math.sin(rotation)
    cos_rotation = Math.cos(rotation)

    dest = Rectangle.new(
      dst_rectangle.x + origin.x,
      dst_rectangle.y + origin.y,
      dst_rectangle.width,
      dst_rectangle.height
    )

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

    points[0] = top_left
    points[1] = top_right
    points[2] = bottom_left
    points[3] = bottom_right
    points
  end

  # Used by sprites to draw to the screen before the rotation and offset takes place
  def dst_rectangle
    Rectangle.new(
      x: x - origin.x,
      y: y - origin.y,
      width: width,
      height: height
    )
  end

  def draw_points(color : Color::RGBA)
    points.each do |point|
      Raylib.draw_circle_v(point, 4, color)
      Raylib.draw_text("#{point.x.round(1)}, #{point.y.round(1)}", point.x, point.y, 12, Raylib::WHITE)
    end
  end
end
