require "../src/crixel"

Crixel.start_window(100, 100)

frames = 0
on(Crixel::FrameProcessed) do |total_time, elapsed_time|
  frames += 1

  if frames == 100
    Crixel.close
  end
end

Crixel.run

if frames == 100
  puts ARGV[0]
else
  puts ARGV[1]
end
