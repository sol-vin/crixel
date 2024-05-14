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

  def initialize(@total_time)
  end

  def started?
    !current_time.nil?
  end

  def ended?
    current_time.nil?
  end

  def start
    @current_time = Time::Span.new(nanoseconds: 0) unless @current_time
    emit Started, self
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
    unless paused?
      @current_time += elapsed_time
      emit Ticked, self
      if @current_time > @trigger_time
        emit Triggered, self
        if loop?
          @current_time -= elapsed_time 
        else
          stop
        end
      end
    end
  end
end
