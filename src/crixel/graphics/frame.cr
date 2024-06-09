
struct Crixel::Frame
  property src : Rectangle
  property dst : Rectangle

  property texture : String
  property? enabled = true
  property duration : Time::Span = Time::Span.new(seconds: 1)

  def initialize(@texture, @src, @dst)
  end
end
