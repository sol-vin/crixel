require "../spec/spec_helper"

success = false

event MyEvent

on(MyEvent) { success = true }

emit MyEvent 

if success
  puts SUCCESS
else
  puts FAILURE
end