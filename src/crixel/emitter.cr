class Crixel::Emitter
  include IPosition
  include IRotation

  alias X = Float32
  alias Y = Float32
  alias Rotation = Float32
  @emit_proc : Proc(X, Y, Rotation, Basic)
  def initialize(&block : Proc(Float32, Float32, Float32, Basic))
    @emit_proc = block
  end

  def emit
    @emit_proc.call(x, y, rotation)    
  end
end