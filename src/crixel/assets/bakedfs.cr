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
  macro install(path = "rsrc", dir = "./")
    module Crixel::Assets::BakedFS
      extend BakedFileSystem

      bake_folder {{path}}, dir: {{dir}}, allow_empty: true
      
      def self.load
        files.each do |baked_file|
          Assets.load("#{{{path}}}#{baked_file.path}", baked_file, baked_file.size)
        end
      end

      on(Crixel::Assets::Setup) do
        load
      end
    end
  end
end