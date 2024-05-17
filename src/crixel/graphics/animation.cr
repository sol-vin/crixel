class Crixel::Animation
  include IOBB

  def self.from_texture_atlas(texture_name : String, x_frames, y_frames)
    r_texture = Assets.get_rtexture(texture_name)
    animation = self.new
    y_frames.times do |y|
      x_frames.times do |y|
        frame = Frame.new
        src = Rectangle.new
        src.x = r_texture.width * (r_texture.width/x_frames)
        src.y = r_texture.height * (r_texture.height/y_frames)
        src.width = r_texture.width/x_frames
        src.height = r_texture.height/y_frames
        frame.src_rectangle = src
        animation.frames << frame
      end
    end
    animation
  end

  property frames = [] of Frame
  property frame_index = 0

  getter? playing = true
  property? looping = true

  @total_time : Time::Span = Time::Span.new
  @current_time : Time::Span = Time::Span.new

  def play
    @playing = true
  end

  def advance_time(elapsed_time : Time::Span)
    return unless playing?
    @current_time += elapsed_time
    while @current_time > current_frame.duration
      @current_time -= current_frame.duration
      @frame_index += 1
      frame_oob = @frame_index >= @frames.size

      if frame_oob && looping?
        @frame_index = 0
      elsif frame_oob
        @frame_index = 0 
        @playing = false
      end
    end
  end

  def current_frame
    frames[frame_index]
  end

  def reset
    @current_time = Time::Span.new
    @frame_index = 0
  end
end