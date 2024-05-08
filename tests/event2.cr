require "../spec/spec_helper"

success = false

event MyEvent, x : Int32

on(MyEvent) { |x| success = true if x == 1234 }

emit MyEvent, 1234

if success
  puts SUCCESS
else
  puts FAILURE
end