module Crixel::Drawable
  property? visible : Bool = true
  getter draw_layer = 0.0_f32

  event DrawLayerChanged, me : self

  def update_layer(v : Number)
    @draw_layer = v.to_f32
    emit DrawLayerChanged, self
  end

  def draw(total_time : Time::Span, elapsed_time : Time::Span)
  end
end
