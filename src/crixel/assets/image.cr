class Crixel::Assets::Image < Crixel::Asset
  getter name : String
  property rimage : Raylib::Image

  def initialize(@name, @rimage)
  end
end

module Crixel::Assets
  @@images = {} of String => Image

  # TODO: Re-enable this when custom preloader gets built
  # add_consumer do |path, io, size|
  #   extension = Path.new(path).extension.downcase
  #   if SUPPORTED_TEXTURES.any? { |ext| extension.upcase[1..] == ext }
  #     content = io.gets_to_end
  #     image = Raylib.load_image_from_memory(extension, content, size)
  #     image = Raylib.load_image_from_image(image)
  #     raise "Image invalid" unless Raylib.image_ready?(image)
  #     add_image Image.new(path, image)
  #     true
  #   else
  #     false
  #   end
  # end

  def self.add_image(image : Image)
    if @@images[image.name]?
      emit Asset::Changed, @@images[image.name], image
      @@images[image.name].rimage = image.rimage
    else
      @@images[image.name] = image
    end
  end

  def self.get_image(name)
    @@images[name]
  end

  def self.get_image?(name)
    @@images[name]?
  end

  def self.get_rimage(name)
    @@images[name].rimage
  end

  def self.get_rimage?(name)
    @@images[name]?.try(&.rimage)
  end

  def self.remove_image(name, unload = true)
    if i = @@images[name]?
      @@images.delete(name)
      if unload
        Raylib.unload_image(i.rimage)
        emit Asset::Destroyed, i
      end
    end
  end

  on(Unload) do
    @@images.values.each do |i|
      Raylib.unload_image(i.rimage)
      emit Asset::Destroyed, i
    end
    @@images.clear
  end
end
