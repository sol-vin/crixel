a = [0,1,2]
a.reverse_each.with_index do |x, i|
  puts "#{x} #{(a.size-1) - i}"
end