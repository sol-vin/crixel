class Crixel::Timer
  # When the timer started
  getter start_time : Float64? = nil

  # When the timer should go off
  property total_time : Float64 = 0.0_f64

  event Ticked, timer : self
  event Started, timer : self
  event Restarted, timer : self
  event Stopped, timer : self
  event Triggered, timer : self
  event Paused, timer : self
  event Unpaused, timer : self

  property? loop : Bool = false
  getter pause_time : Float64? = nil

  def initialize(@total_time)
  end

  def started?
    !start_time.nil?
  end

  def ended?
    start_time.nil?
  end

  def start
    @start_time = R.get_time unless @start_time
    emit Started, self
  end

  def pause
    @pause_time = R.get_time
    emit Paused, self
  end

  def unpause
    time_elapsed = @pause_time - @start_time
    @start_time = R.get_time - time_elapsed
    @pause_time = nil
    emit Unpaused, self
  end

  def paused?
    !!@pause_time
  end

  def stop
    @start_time = nil
    emit Stopped, self
  end

  def restart
    @start_time = R.get_time

    if @start_time
      emit Restarted, self
    else
      emit Started, self
    end
  end

  def tick
    unless paused?
      emit Ticked, self
      if R.get_time - @start_time
        emit Triggered, self
        if loop?
          @start_time = R.get_time
        else
          stop
        end
      end
    end
  end
end
