require "./crixel"
require "./crixel/audio"

class PlayState < Crixel::State
  @last = 0.0
  @texture = Raylib::Texture2D.new

  @c : Crixel::Sprite? = nil

  def setup
    # camera.offset = Raylib::Vector2.new(x: 200, y: 150)
    RAudio.play_sound(Crixel::Assets.get_sound("default_rsrc/flixel.mp3"))
    camera.zoom = 0.7_f32
    camera.offset.x = 200
    camera.offset.y = 150

    @c = Crixel::Sprite.new(width: 400, height: 300)
    @c.not_nil!.origin = Raylib::Vector2.new(x: @c.not_nil!.width/2, y: @c.not_nil!.height/2)
    add(@c.not_nil!)
  end

  def pre_update
    @c.not_nil!.rotation = (Raylib.get_time).to_f32
  end
end

Crixel::Assets::BakedFS.bake(path: "rsrc")

# on Crixel::Assets::Setup do
#   Crixel::Assets.load_from_path("rsrc/wire.png")
# end

Crixel.run(400, 300, PlayState.new)

# puts 0.0_f32.zero?
