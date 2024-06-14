class Crixel::Timer
  # When the timer started
  getter current_time : Time::Span? = nil

  # When the timer should go off
  property trigger_time : Time::Span = Time::Span.new(nanoseconds: 0)

  event Ticked, timer : self
  event Started, timer : self
  event Restarted, timer : self
  event Stopped, timer : self
  event Triggered, timer : self
  event Paused, timer : self
  event Unpaused, timer : self

  property? loop : Bool = false
  getter? paused : Bool = false

  def initialize(@trigger_time)
  end

  def started?
    !@current_time.nil?
  end

  def ended?
    @current_time.nil?
  end

  def start
    unless @current_time
      @current_time = Time::Span.new(nanoseconds: 0)
      emit Started, self
    end
  end

  def pause
    @paused = true
    emit Paused, self
  end

  def unpause
    @paused = false
    emit Unpaused, self
  end

  def stop
    @current_time = nil
    emit Stopped, self
  end

  def restart
    if @current_time
      @current_time = Time::Span.new(nanoseconds: 0)
      emit Restarted, self
    else
      @current_time = Time::Span.new(nanoseconds: 0)
      emit Started, self
    end
  end

  def tick(elapsed_time : Time::Span)
    if (c_t = @current_time) && !paused?
      c_t += elapsed_time
      emit Ticked, self
      if c_t > @trigger_time
        emit Triggered, self
        if loop?
          c_t -= elapsed_time
        else
          stop
        end
      end
      @current_time = c_t
    end
  end

  def percent
    (@current_time.not_nil!.total_seconds/@trigger_time.total_seconds).clamp(0.0, 1.0)
  end

  def inv_percent
    1.0 - (@current_time.not_nil!.total_seconds/@trigger_time.total_seconds).clamp(0.0, 1.0)
  end
end
