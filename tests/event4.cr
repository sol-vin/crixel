require "../spec/spec_helper"

my_event1_runs = 0
my_event2_runs = 0

event MyEvent1
event MyEvent2

class MyClass
  attach MyEvent1
  attach MyEvent2
end

m = MyClass.new

m.on_my_event1 { my_event1_runs += 1 }

m.on_my_event2 { my_event2_runs += 1 }

m.emit_my_event1
m.emit_my_event1
m.emit_my_event2
m.emit_my_event2
m.emit_my_event2
m.emit_my_event2

if my_event1_runs == 2 && my_event2_runs == 4
  puts SUCCESS
else
  puts FAILURE 
end