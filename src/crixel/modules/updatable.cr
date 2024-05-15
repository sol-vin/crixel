module Crixel::Updatable
  property? active : Bool = true
  getter update_layer = 0.0_f32

  event UpdateLayerChanged, me : self

  def update_layer(v : Number)
    @update_layer = v.to_f32
    emit UpdateLayerChanged, self
  end

  def update(total_time : Time::Span, elapsed_time : Time::Span)
  end
end
