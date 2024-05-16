class Crixel::Image
  # TODO: FInish this
  def self.from_screen
  end

  def self.from_texture(texture : Assets::Texture)
  end

  def self.from_file(filename : String)
  end

  def initialize(width : UInt32, height : UInt32, color : Color::RGBA::WHITE)
  end

  def make_linear_gradient
    # GenImageGradientLinear
  end

  def make_radial_gradient
    # GenImageGradientRadial
  end

  def make_square_gradient
    # GenImageGradientSquare
  end

  def make_checkered
  end

  def make_white_noise
  end

  def make_perlin_noise
  end

  def make_cellular
  end

  def make_text
    # ImageTextEx
  end


  def power_of_two
  end

  def crop
  end

  def alpha_crop
  end

  def alpha_clear
  end

  def alpha_mask
  end

  def alpha_premultiply
  end

  def blur_gaussian
  end

  def resize
  end

  def resize_nearest_neighbor
  end

  def resize_canvas
  end

  def mipmaps
  end

  def dither
  end

  def flip_v
  end

  def flip_h
  end

  def rotate
  end

  def rotate_cw
  end

  def rotate_ccw
  end

  def color_tint
  end

  def color_invert
  end

  def color_greyscale
  end

  def color_contrast
  end

  def color_brightness
  end

  def color_replace
  end

  def load_colors
  end

  def get_pixel(x, y) : Color
    Color::RGBA::WHITE
  end

  def clear_background
  end

  def draw_pixel
  end

  def draw_line
  end

  def draw_circle
  end

  def draw_rectangle
  end

  def draw_image
  end

  def draw_text
  end

  def clone
    # Raylib.image_copy
  end

  def make_texture
  end
end