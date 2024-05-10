require "baked_file_system"

module Crixel::Assets
  def self.load(baked_file : BakedFileSystem::BakedFile)
    if SUPPORTED_TEXTURES.any? {|ext| Path.new(baked_file.path).extension.upcase[1..] == ext}
      content = baked_file.gets_to_end
      image = Raylib.load_image_from_memory(".png", content, baked_file.size)
      texture = Raylib.load_texture_from_image(image)
      @@textures[baked_file.path] = texture
    end
  end
end

module Crixel::Assets::BakedFS
  extend BakedFileSystem

  bake_folder "rsrc/", dir: "./", allow_empty: true
  
  def self.load
    files.each do |baked_file|
      Assets.load(baked_file)
    end
  end

  on(Crixel::Assets::Setup) do
    load
  end
end