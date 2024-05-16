class Crixel::Image
  # TODO: FInish this
  def self.from_screen(name = "")
    image = Raylib.load_image_from_screen
    Image.new(name. image)
  end

  def self.from_texture(texture : Assets::Texture)
    image = Raylib.load_image_from_texture(texture.rtexture)
    Image.new(name. image)
  end

  def self.from_texture(texture_name : String)
    image = Raylib.load_image_from_texture(Assets.get_texture(texture_name).rtexture)
    Image.new(name. image)
  end

  def self.from_file(filename : String)
    image = Raylib.load_image(filename)
    Image.new(name. image)
  end

  def self.make_linear_gradient
    # GenImageGradientLinear
  end

  def self.make_radial_gradient
    # GenImageGradientRadial
  end

  def self.make_square_gradient
    # GenImageGradientSquare
  end

  def self.make_checkered
  end

  def self.make_white_noise
  end

  def self.make_perlin_noise
  end

  def self.make_cellular
  end

  def self.make_text
    # ImageTextEx
  end

  @image : Raylib::Image = Raylib::Image.new
  @name : String
  
  def initialize(name : String = "", width : UInt32, height : UInt32, color : Color = Color::RGBA::WHITE)
    @image = Raylib.gen_image_color(width, height, color.to_raylib)
    @name = (name.empty? ? "@Image#{@image.id}@" : name) 
    image = Assets::Image.new(@name, @image)
    
    image.on_destroyed(once: true) do
      Assets.remove_image(@name, unload: false) # Its already unloaded
      @image = Raylib::Image.new
    end

    Assets.add_image(image)
  end

  def initialize(name : String = "", @image : Raylib::Image)
    @name = (name.empty? ? "@Image#{@image.id}@" : name) 
    image = Assets::Image.new(@name, @image)
    
    image.on_destroyed(once: true) do
      Assets.remove_image(@name, unload: false) # Its already unloaded
      @image = Raylib::Image.new
    end

    Assets.add_image(image)
  end

  def destroy
    Assets.remove_image(@name)
    @image = Raylib::Image.new
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