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

  attach_self Ticked
  attach_self Started
  attach_self Restarted
  attach_self Stopped
  attach_self Triggered
  attach_self Paused
  attach_self Unpaused

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
    on_started
  end

  def pause
    @pause_time = R.get_time
    on_paused
  end

  def unpause
    time_elapsed = @pause_time - @start_time
    @start_time = R.get_time - time_elapsed
    @pause_time = nil
    on_unpaused
  end

  def paused?
    !!@pause_time
  end

  def stop
    @start_time = nil
    on_stopped
  end

  def restart
    @start_time = R.get_time

    if @start_time
      on_restarted
    else
      on_started
    end
  end

  def tick
    unless paused?
      on_ticked
      if R.get_time - @start_time
        on_triggered
        if loop?
          @start_time = R.get_time
        else
          stop
        end
      end
    end
  end
end
