module A
  class_property test = 1234
end

class B
  include A
end

puts B.test
B.test = 4321
puts B.test

