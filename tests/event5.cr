require "../spec/spec_helper"

success = false

class MyClass
  event MyEvent
  extend_event MyEvent
end

MyClass.on_my_event { success = true }

MyClass.emit_my_event

if success
  puts SUCCESS
else
  puts FAILURE 
end