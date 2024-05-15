require "file_utils"



FileUtils.cd("examples") do
  puts "BUILDING EXAMPLES FROM #{FileUtils.pwd}"
  begin
    FileUtils.rm_r("_build")
  rescue
  end
  
  FileUtils.mkdir_p("_build")

  # FileUtils.mkdir_p("_build/rsrc")
  Dir.entries(FileUtils.pwd).each do |name|
    path = Path[name]
    next if path.basename =~ /^\.{1,2}$/ || path.basename =~ /^_build$/

    puts " - BUILDING EXAMPLE #{path.basename}"

    FileUtils.cd(path) do
      FileUtils.cp_r("../../default_rsrc", "./")

      `shards install`

      output = `shards build --release -s -p -t`

      {% if flag?(:win32) %}
        FileUtils.cp(Dir.glob("./bin/*.exe"), "../_build/")

        FileUtils.cp("../../lib/raylib-cr/rsrc/native/windows/raylib.dll", "../_build/raylib.dll")
        FileUtils.cp("../../lib/raylib-cr/rsrc/native/windows/raygui.dll", "../_build/raygui.dll")
      {% else %}
        FileUtils.cp(Dir.glob("./bin/*"), "../_build/")
      {% end %}

      FileUtils.rm_r("./default_rsrc")

    end
  end
end
