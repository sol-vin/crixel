require "./crixel"


class PlayState < Crixel::State
  def setup
  end

  def draw
    Raylib.draw_texture_ex(Crixel::Assets.get_texture("/test.png"), Raylib::Vector2.zero, 0, 0.05, Raylib::WHITE)
  end
end

Crixel.run(400, 300, PlayState.new)

# require "raylib-cr"



# Raylib.init_window(400, 200, "test")
 
# file = File.open("rsrc/test.png")
# content = file.gets_to_end
# image = Raylib.load_image_from_memory(".png", content, file.size)
# file.close

# texture = Raylib.load_texture_from_image(image)
# until Raylib.close_window?
#   Raylib.begin_drawing
#   Raylib.clear_background(Raylib::WHITE)
#   Raylib.draw_texture_ex(texture, Raylib::Vector2.zero, 0, 0.05, Raylib::WHITE)
#   Raylib.end_drawing
# end

# Raylib.close_window