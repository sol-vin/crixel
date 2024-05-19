macro counter(max, &block)
  %finished_channel = Channel(Nil).new(capacity: {{max}})
  {{max}}.times do | %x |
    spawn do
      ->({{block.args.first}} : Int32) do 
        {{block.body}}
      end.call(%x)
      %finished_channel.send nil
    end
  end

  {{max}}.times do |n| 
    %finished_channel.receive
  end
end





COUNTER_MAX = (Int32::MAX/100).to_i

array = StaticArray(UInt32, 10).new(0_u32)
time1 = Time.measure do
  counter(array.size) do |x|
    COUNTER_MAX.times do
      array[x] += 1
    end
  end
end
puts "1 #{array.map {|x| x == COUNTER_MAX}}"
puts " - #{time1.total_seconds}"

# time2 = Time.measure do
#   array = StaticArray(UInt32, 10).new(0_u32)
#   finished_channel = Channel(Nil).new(capacity: 10)
#   10.times do |x|
#     spawn do
#       COUNTER_MAX.times do
#         array[x] += 1
#       end
#       finished_channel.send nil
#     end
#   end

#   10.times {finished_channel.receive}
# end
# puts "2 #{array.map {|x| x == COUNTER_MAX}}"
# puts " - #{time2.total_seconds}"
