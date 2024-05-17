class Crixel::Animation
  def self.from_spritesheet(texture_name : String, x_frames : UInt32, y_frames : UInt32)
    r_texture = Assets.get_rtexture(texture_name)
    animation = self.new
    y_frames.times do |y|
      x_frames.times do |y|
        frame = Frame.new
        src = Rectangle.new
        src.x = (r_texture.width * (r_texture.width/x_frames)).to_f32
        src.y = (r_texture.height * (r_texture.height/y_frames)).to_f32
        src.width = (r_texture.width/x_frames).to_f32
        src.height = (r_texture.height/y_frames).to_f32
        frame.src_rectangle = src
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

  event TimeAdvanced, me : self, current_time : Time::Span
  event FrameAdvanced, me : self
  event Played, me : self
  event Replayed, me : self
  event Stopped, me : self
  event Paused, me : self
  event Unpaused, me : self

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
end