
Design:



# TODO
  <!-- - Raylib compatable types - Vector2, Color, Rectangle -->
  <!-- - Timer -->
  <!-- - Primitives (Circle, Rectangle, Point, etc) -->
  - RenderTexture
    <!-- - Render texture camera -->
    - Render texture objects( rt as a state/in a state)?
      - RenderTexture addon for State?
    - Render texture for Crixel.run to allow scaling
  <!-- - Update and Draw layer ordering
    - Create "delete/add" queue to be run between updates and draws to prevent .dup or looping errors -->
  - Palettes
    - Built in palettes
      - `require "crixel/default/palettes`
      - `Crixel::Pallettes::Pico8`
        - `COLOR1 = Color::RGBA.new()`
        - `COLORS = [] of Color::RGBA`
        - `self.to_palette : Crixel::Palette`
  - Image
    - Needs it own special drawing functions.
    - 
  - Tilemap
  - Collision Manager
  - Animation
    -  Frame (ISprite?)
       -  Holds texture info and src/dst/offset etc frame info
  -  Importer
     -  Aseprite
  - Crixel::Config
    - Config for run
  - Baked File System Enhancements
    - Custom loader
      - Opens raylib during compilation process to make asset entries in Assets.
      - Should include metadata like texture size etc for better responsiveness 
      - Include a progress bar
      - Should automatically halt back to compilation process
    - Proper compression for baked filesystem
      - Check to make sure compression is working for baked_file_system
      - If not make sol-vin/baked_file_system the way it should be (full customize)
    - Configuration
      - file.png, _file.png.yml
  - Scissor mode?
    - Scissor
  - Shaders?
    - see begin_shader_mode and https://github.com/raysan5/raylib/blob/master/examples/shaders/shaders_texture_outline.c
  - Particles
  - GUI
  - Debugger
    - Flx.watch equivalent (must be a macro probably)
  - Crixel::Sound
    - Own data type (non Basic)
    - use load_sound_alias to prevent changing original source.
    - hook Crixel::Sound#on_destroyed/on_changed to