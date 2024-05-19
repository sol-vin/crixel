
Design:



# TODO
  <!-- - Animation
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
        - R - Replay -->
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





Multithreaded possibilities

        Channels
State <-----------> Objects

Basic Idea
```crystal
class Basic
  property add_proc : Proc(Basic, Nil) = -> {|b| }

end

class State
  @objects = [] of Basic
  @add_object_channel = Channel(Basic).new
  @done_updating_channel = Channel(Nil).new

  def add(b : Basic)
    @objects << b
    b.add_proc = -> { |b| add_object_channel.send b }
  end

  def update
    total_objects = @objects.size

    @objects.each do |o|
      spawn(name: "#{self.class.to_s} - #{o.name}") do
        o.update
        @done_updating_channel.send nil
      end
    end

    # block until objects finish
    total_objects.times { @done_updating_channel.receive }
  end

  def draw
    @objects.each do |o|
      o.draw
    end
  end
end
```

ADV IDEA
```crystal
class Basic
  @parent : State
  
  def initialize(@parent)
  end

  def update
    send State::Add, Basic.new
  end
end

class State
  @objects = [] of Basic

  job(Add, object : Basic) do |object|
    @objects << object
  end

  job(Remove, object : Basic) do |object|
    @objects.delete object
  end

  counter(Update, object : Basic) do |object|
    object.update
  end

  def update
    #Queue jobs
    @objects.each {|o| queue Update, o }
    wait_for_counter(Update, @objects.size)
    run Add
    run Remove
  end
end
```

Notes:
  - Need a way to "jobify" each aspect of the updater?
  - Frame 1: Update -> Spawn(Draw)]
  - Frame 2: Update -Wait(Draw)-> Spawn(Draw)
  - etc.
  - Need a raylib command buffer
    - Should contain some way to send all the arbitrary commands to raylib

