require "../spec/spec_helper"
success = false 

class MyTest
  event MyEvent, x : self
  
  on(MyEvent) do |x|
    success = true
  end

  def test
    emit MyEvent, self
  end
end

MyTest.new.test

if success
  puts SUCCESS
else
  puts FAILURE
end
