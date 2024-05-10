require "baked_file_system"

module ::Crixel::Assets::BakedFS
  extend BakedFileSystem

  def self.load_files
    files.each do |baked_file|
      puts "Loading #{baked_file.original_path}#{baked_file.path}"
      ::Crixel::Assets.load("#{baked_file.original_path}#{baked_file.path}", baked_file, baked_file.size)
    end
  end

  on(::Crixel::Assets::Setup) do
    load_files
  end

  macro bake(path = "rsrc", dir = "./")
    module ::Crixel::Assets::BakedFS
      bake_folder {{path}}, dir: {{dir}}, allow_empty: true
      
      begin
        Dir.mkdir "#{{{dir}}}#{{{path}}}"
      rescue File::AlreadyExistsError
      end
    end
  end
end
