module Crixel::Assets::BakedFS
  extend BakedFileSystem

  bake_folder "rsrc/", dir: "./", allow_empty: true
end