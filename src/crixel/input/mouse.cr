module Crixel::Mouse
  class_getter x : Int32 = 0
  class_getter y : Int32 = 0
  class_getter last_x : Int32 = 0
  class_getter last_y : Int32 = 0

  def self.position : Raylib::Vector2
    Raylib::Vector2.new(
      x: x,
      y: y
    )
  end

  def self.delta : Raylib::Vector2
    Raylib::Vector2.new(
      x: x - last_x,
      y: y - last_y
    )
  end

  def self.uv_position : Raylib::Vector2
    Raylib::Vector2.new(
      x: x/Crixel.width,
      y: y/Crixel.height
    )
  end

  def self.uv_delta : Raylib::Vector2
    Raylib::Vector2.new(
      x: (x - last_x)/Crixel.width,
      y: (y - last_y)/Crixel.height
    )
  end

  def self.update
    @@last_x = @@x
    @@last_y = @@y
    @@x = Raylib.get_mouse_x
    @@y = Raylib.get_mouse_y
  end
end
