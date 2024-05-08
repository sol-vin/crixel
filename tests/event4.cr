require "../spec/spec_helper"

my_event1_runs = 0

event MyEvent1

class MyClass
  attach MyEvent1
end

m = MyClass.new

m.on_my_event1 { my_event1_runs += 1 }

m.emit_my_event1
m.emit_my_event1
m.emit_my_event1


if my_event1_runs == 3
  puts SUCCESS
else
  puts FAILURE 
end