module Crixel::Mouse
  class_getter x : Int32 = 0
  class_getter y : Int32 = 0
  class_getter last_x : Int32 = 0
  class_getter last_y : Int32 = 0

  def self.position : Vector2
    Vector2.new(
      x: x,
      y: y
    )
  end

  def self.delta : Vector2
    Vector2.new(
      x: x - last_x,
      y: y - last_y
    )
  end

  def self.uv_position : Vector2
    Vector2.new(
      x: x/Crixel.window_width,
      y: y/Crixel.window_height
    )
  end

  def self.uv_delta : Vector2
    Vector2.new(
      x: (x - last_x)/Crixel.window_width,
      y: (y - last_y)/Crixel.window_height
    )
  end

  def self.update
    @@last_x = @@x
    @@last_y = @@y
    @@x = Raylib.get_mouse_x
    @@y = Raylib.get_mouse_y
  end
end
