require "baked_file_system"

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

      begin
        Dir.mkdir {{path}}
      rescue File::AlreadyExistsError
      end
    end
  end
end
