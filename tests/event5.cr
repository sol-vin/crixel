require "../spec/spec_helper"

my_event1_runs = 0
my_event2_runs = 0

event MyEvent1, x : Int32, z : Int32
event MyEvent2, y : Int32,  z : Int32

class MyClass
  attach MyEvent1
  attach MyEvent2
end

m = MyClass.new

m.on_my_event1 { |x, _| my_event1_runs += x }

m.on_my_event2 { |y, _| my_event2_runs += y }

m.emit_my_event1(1, 0)
m.emit_my_event1(2, 0)
m.emit_my_event2(3, 0)
m.emit_my_event2(4, 0)
m.emit_my_event2(5, 0)
m.emit_my_event2(6, 0)

if my_event1_runs == 3 && my_event2_runs == 18
  puts SUCCESS
else
  puts FAILURE 
end