module Crixel::IUpdate
  property? active : Bool = true
  property update_layer = 0.0_f32

  def update(elapsed_time : Time::Span)
  end
end
