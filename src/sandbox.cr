require "./crixel/event/**"

event ::MyEvent

on ::MyEvent do 
  puts "Hi!"
end

emit ::MyEvent
emit ::MyEvent

event AEvent, x : Int32

on AEvent do |x|
  puts "Hi2! #{x}"
end

emit AEvent, 10
emit AEvent, 1234


event Clicked
event Moved, x : Int32, y : Int32

class MyObject
  attach Clicked
  attach Moved
end

o = MyObject.new

o.on_clicked do
  puts "#{o} was clicked!"
end

def move(x : Int32, y : Int32)
  puts "I moved!"
end

o.on_moved &->move(Int32, Int32)


o.emit_clicked
o.emit_moved(10, 20)


# module My::Test::Name
# end

# macro test(name)
#   {% if Path["My::Test::#{name}"].resolve? %}
#     {% puts "HI!" %}
#   {% end %}
# end

# test Name
