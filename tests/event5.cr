require "../spec/spec_helper"

my_event1_runs = 0

event MyEvent1, x : Int32
event MyEvent2, y : String
event MyEvent3, z : Float32

class MyClass
  attach MyEvent1
  attach MyEvent2
  attach MyEvent3
end

m = MyClass.new

m.on_my_event1 { |x| my_event1_runs += x }
m.on_my_event2 { |x| }
m.on_my_event3 { |x| }

m.emit_my_event1(1)
m.emit_my_event1(2)
m.emit_my_event2("Hi")
m.emit_my_event3(3.3_f32)


if my_event1_runs == 3
  puts SUCCESS
else
  puts FAILURE 
end