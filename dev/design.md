
Design:



# TODO
  - Animation
    - Make testbed for this
      - Should play animation
        - WASD - Character position
        - Arrows - Frame position
        - Shift WASD - Character origin
        - Shift Arrows - Frame origin
        - QE - Character rotation
        - ,. - Frame rotation
        - Space - Play/Pause
        - Shift Space - Stop
        - R - Replay
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
  <!-- - Raylib compatable types - Vector2, Color, Rectangle -->
  <!-- - Timer -->
  <!-- - Primitives (Circle, Rectangle, Point, etc) -->
  - RenderTexture
    <!-- - Render texture camera -->
    <!-- - Render texture objects( rt as a state/in a state)?
      - RenderTexture addon for State? -->
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
    - Color functions
      - HSV to RGBA etc etc
      - LAB and other colors
      - to_rgba for each
  - Image
    - Needs it own special drawing functions.
    - To Asset
    - Needs to be finished
  - Tilemap
  - Collision Manager
    - Quadtree
      - NodeObject
        - body : Rectangle
        - object : Crixel::Basic
    - Add similarly to input system
      - Add to Crixel::State via monkey patch
      - Include callback for on(Basic::Added)
      - Use `Set` for collision mask since `#includes?` has an O(1) time
  -  Importer
     -  Aseprite
        -  Detect if imported item (ex: file.png and _file.png.json)
           -  Is a json?
           -  Has ["meta"]["app"] == "https://www.aseprite.org/"
           -  Crixel::Asset now needs a `config = {} of String => String`
              -  File Extension => Assets Path
  - Crixel::Config
    - Config for run
  - Scissor mode?
    - Scissor
  - Shaders?
    - see begin_shader_mode and https://github.com/raysan5/raylib/blob/master/examples/shaders/shaders_texture_outline.c
  - Particles
  - GUI
  - Debugger
    - Flx.watch equivalent (must be a macro probably)
  <!-- - Crixel::Sound
    - Own data type (non Basic)
    - use load_sound_alias to prevent changing original source.
    - hook Crixel::Sound#on_destroyed/on_changed to -->