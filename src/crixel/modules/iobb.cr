require "./iposition"
require "./isize"
require "./irotation"

module Crixel::IOBB
  include IBody
  include IRotation

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
    points[2] = bottom_right
    points[3] = bottom_left
    points
  end

  def dst_rectangle
    Rectangle.new(
      x: x - origin.x,
      y: y - origin.y,
      width: width,
      height: height
    )
  end

  def draw_points(color : Color, display_text = false)
    points.each do |point|
      Raylib.draw_circle_v(point, 4, color.to_raylib)
      Raylib.draw_text("#{point.x.round(1)}, #{point.y.round(1)}", point.x, point.y, 12, Raylib::WHITE) if display_text
    end
  end

  # Bounding box around the sprite's drawing area (includes rotation)
  def draw_area_bounding_box(tint : Color, fill = false)
    points = self.points
    min_x = points.map(&.x).min
    min_y = points.map(&.y).min
    max_x = points.map(&.x).max
    max_y = points.map(&.y).max

    Rectangle.draw(min_x, min_y, max_x - min_x, max_y - min_y, tint, fill)
  end

  def draw_obb(tint : Color)
    points = self.points
    color = tint.to_raylib
    Raylib.draw_line(points[0].x, points[0].y, points[1].x, points[1].y, color)
    Raylib.draw_line(points[1].x, points[1].y, points[2].x, points[2].y, color)
    Raylib.draw_line(points[2].x, points[2].y, points[3].x, points[3].y, color)
    Raylib.draw_line(points[3].x, points[3].y, points[0].x, points[0].y, color)
  end

  def draw_rotation(scale = 40, tint : Color = Color::RGBA::WHITE)
    Circle.draw(x, y, 3, tint)
    line = Vector2.unit_y.rotate(rotation).scale(scale) * -1
    line += position
    Raylib.draw_line(x, y, line.x, line.y, tint.to_raylib)
  end
end
