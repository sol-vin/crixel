require "./crixel"
require "./crixel/audio"

class PlayState < Crixel::State
  @last = 0.0
  @texture = Raylib::Texture2D.new
  def setup
    RAudio.play_sound(Crixel::Assets.get_sound("default_rsrc/flixel.mp3"))
    add(Crixel::Sprite.new(width: 100, height: 100))
  end
end

# Crixel::Assets::BakedFS.bake(path: "rsrc")

# on Crixel::Assets::Setup do
#   Crixel::Assets.load_from_path("rsrc/wire.png")
# end

Crixel.run(400, 300, PlayState.new)

# module A
#   def a
#     puts "A.a"
#   end
# end

# module B
#   include A
#   def b
#     a
#     puts "B.b"
#   end
# end

# class C
#   include B
# end

# c = C.new
# c.a
# c.b