class Crixel::Animation
  def self.from_spritesheet(texture_name : String, x_frames : UInt32, y_frames : UInt32, x_offset = -0.5_f32, y_offset = -0.5_f32, duration = Time::Span.new(nanoseconds: 100_000_000))
    r_texture = Assets.get_rtexture(texture_name)
    animation = self.new
    y_frames.times do |y|
      x_frames.times do |x|
        src = Rectangle.new
        frame_width = (r_texture.width/x_frames).to_f32
        frame_height = (r_texture.height/y_frames).to_f32

        src.x = (x * frame_width)
        src.y = (y * frame_height)
        src.width = frame_width
        src.height = frame_height
        dst = Rectangle.new(x_offset * frame_width, y_offset * frame_height, frame_width, frame_height)

        frame = Frame.new(texture_name, src, dst)
        frame.duration = duration
        animation.frames << frame
      end
    end
    animation
  end

  property frames = [] of Frame
  getter frame_index = 0

  getter? playing = true
  property? looping = true

  @current_time : Time::Span = Time::Span.new

  single_event TimeAdvanced, me : self, current_time : Time::Span
  single_event FrameAdvanced, me : self
  single_event Played, me : self
  single_event Replayed, me : self
  single_event Stopped, me : self
  single_event Paused, me : self
  single_event Unpaused, me : self

  def play
    @playing = true
    if paused?
      emit Unpaused, self
    else
      emit Played, self
    end
  end

  def stop
    @playing = false
    reset
    emit Stopped, self
  end

  def pause
    @playing = false
    emit Paused, self
  end

  def paused?
    !playing? && (@current_time.total_seconds > 0)
  end

  def reset
    @current_time = Time::Span.new
    @frame_index = 0
  end

  def replay
    @playing = true
    reset
    emit Replayed, self
  end

  def advance_time(elapsed_time : Time::Span)
    return unless playing?
    @current_time += elapsed_time
    emit TimeAdvanced, self, @current_time
    while @current_time > current_frame.duration
      @current_time -= current_frame.duration
      @frame_index += 1
      emit FrameAdvanced, self
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
end
