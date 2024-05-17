require "./isprite"
struct Crixel::Frame
  include ISprite

  property? enabled = true
  property duration : Time::Span = Time::Span.new(seconds: 1)
end