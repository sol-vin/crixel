struct Raylib::Vector2
  def to_crixel
    Crixel::Vector2.new(x, y)
  end
end

struct Crixel::Vector2
  property x : Float32 = 0.0_f32
  property y : Float32 = 0.0_f32

  def self.zero : Vector2
    Vector2.new(0, 0)
  end

  def self.one : Vector2
    Vector2.new(1, 1)
  end

  def self.unit_x : Vector2
    Vector2.new(x: 1, y: 0)
  end

  def self.unit_y : Vector2
    Vector2.new(x: 0, y: 1)
  end

  def self.zero_x : Vector2
    Vector2.new(x: 0, y: 1)
  end

  def self.zero_y : Vector2
    Vector2.new(x: 1, y: 0)
  end

  def initialize(x : Number = 0.0_f32, y  : Number = 0.0_f32)
    @x = x.to_f32
    @y = y.to_f32
  end

  def add(v2 : Vector2) : Vector2
    Raymath.vector2_add(self.to_raylib.to_raylib, v2).to_crixel
  end

  def add_value(add : Number) : Vector2
    Raymath.vector2_add_value(self.to_raylib, add.to_f32).to_crixel
  end

  def subtract(v2 : Vector2) : Vector2
    Raymath.vector2_subtract(self.to_raylib, v2).to_crixel
  end

  def subtract_value(sub : Number) : Vector2
    Raymath.vector2_subtract_value(self.to_raylib, sub.to_f32).to_crixel
  end

  def length : LibC::Float
    Raymath.vector2_length(self.to_raylib).to_crixel
  end

  def length_sqr : LibC::Float
    Raymath.vector2_length_sqr(self.to_raylib).to_crixel
  end

  def dot_product(v2 : Vector2) : LibC::Float
    Raymath.vector2_dot_product(self.to_raylib, v2).to_crixel
  end

  def distance(v2 : Vector2) : LibC::Float
    Raymath.vector2_distance(self.to_raylib, v2).to_crixel
  end

  def angle(v2 : Vector2) : LibC::Float
    Raymath.vector2_angle(self.to_raylib, v2).to_crixel
  end

  def line_angle(v2 : Vector2) : LibC::Float
    Raymath.vector2_line_angle(self.to_raylib, v2).to_crixel
  end

  def scale(scale : Number) : Vector2
    Raymath.vector2_scale(self.to_raylib, scale.to_f32).to_crixel
  end

  def multiply(v2 : Vector2) : Vector2
    Raymath.vector2_multiply(self.to_raylib, v2).to_crixel
  end

  def negate : Vector2
    Raymath.vector2_negate(self.to_raylib).to_crixel
  end

  def divide(v2 : Vector2) : Vector2
    Raymath.vector2_divide(self.to_raylib, v2).to_crixel
  end

  def normalize : Vector2
    Raymath.vector2_normalize(self.to_raylib).to_crixel
  end

  def transform(mat : Matrix) : Vector2
    Raymath.vector2_transform(self.to_raylib, mat).to_crixel
  end

  def lerp(v2 : Vector2, amount : Number) : Vector2
    Raymath.vector2_lerp(self.to_raylib, v2, amount.to_f32).to_crixel
  end

  def reflect(normal : Vector2) : Vector2
    Raymath.vector2_reflect(self.to_raylib, normal).to_crixel
  end

  def rotate(angle : Number) : Vector2
    Raymath.vector2_rotate(self.to_raylib, angle.to_f32).to_crixel
  end

  def move_towards(target : Vector2, max_distance : Number) : Vector2
    Raymath.vector2_move_towards(self.to_raylib, target, max_distance.to_f32).to_crixel
  end

  # Operators for convenience

  def +(other : Vector2) : Vector2
    self.to_raylib.add(other).to_crixel
  end

  def +(other : Number) : Vector2
    self.to_raylib.add_value(other).to_crixel
  end

  def -(other : Vector2) : Vector2
    self.to_raylib.subtract(other).to_crixel
  end

  def -(other : Number) : Vector2
    self.to_raylib.subtract_value(other).to_crixel
  end

  def *(other : Vector2) : Vector2
    self.to_raylib.multiply(other).to_crixel
  end

  def *(other : Number) : Vector2
    self.to_raylib.scale(other).to_crixel
  end

  def /(other : Vector2) : Vector2
    self.to_raylib.divide(other).to_crixel
  end

  def /(other : Number) : Vector2
    self.to_raylib.scale((1/other).to_f32).to_crixel
  end

  def to_raylib
    Raylib::Vector2.new(x: x, y: y)
  end
end