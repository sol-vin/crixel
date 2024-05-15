require "file_utils"
require "yaml"


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
      FileUtils.rm_r("bin")
      FileUtils.cp_r("../../default_rsrc", "./")

      `shards install`
      shard_yml = YAML.parse("")
      File.open("shard.yml") do |file|
        shard_yml = YAML.parse(file.gets_to_end)
      end

      shard_yml["targets"].as_h.each do |target, _|
        puts "  - building target: #{target}"
        output = `shards build #{target.as_s} --release -s -p -t`

        puts output.lines[0..20].join("\n")
      end
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
