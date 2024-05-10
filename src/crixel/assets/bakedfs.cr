require "baked_file_system"

module ::Crixel::Assets::BakedFS
  extend BakedFileSystem

  def self.load_files(path, dir)
    files.each do |baked_file|
      next unless File.exists?("#{dir}#{path}#{baked_file.path}")
      ::Crixel::Assets.load("#{path}#{baked_file.path}", baked_file, baked_file.size)
    end
  end

  macro bake(path = "rsrc", dir = "./")
    module ::Crixel::Assets::BakedFS
      bake_folder {{path}}, dir: {{dir}}, allow_empty: true
      
      on(::Crixel::Assets::Setup) do
        load_files({{path}}, {{dir}})
      end

      begin
        Dir.mkdir "#{{{dir}}}#{{{path}}}"
      rescue File::AlreadyExistsError
      end
    end
  end
end
