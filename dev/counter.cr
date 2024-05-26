COUNTER_MAX = (Int32::MAX/10).to_i

time1 = Time.measure do
  array = StaticArray(Int32, 10).new(0)
  10.times do |x|
    print '.'
    COUNTER_MAX.times do
      array[x] += 1
    end
  end

  puts "1 #{array.map { |x| x == COUNTER_MAX }}"
end
puts " - #{time1.total_seconds}"

time2 = Time.measure do
  array = StaticArray(Int32, 10).new(0)
  finished_channel = Channel(Nil).new(capacity = 10)
  10.times do |x|
    spawn do
      COUNTER_MAX.times do
        array[x] += 1
      end
      finished_channel.send nil
    end
  end

  10.times { finished_channel.receive }

  puts "2 #{array.map { |x| x == COUNTER_MAX }}"
end
puts " - #{time2.total_seconds}"
