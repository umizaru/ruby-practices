shots = ARGV[0].gsub('X', '10').split(',').map(&:to_i)

frames = []
9.times do
  rolls = shots.shift(2)
  if rolls.first == 10
    frames << [rolls.first, 0]
    shots.unshift(rolls.last)
  else
    frames << rolls
  end
end
frames << shots
# => [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, 0], [9, 1], [8, 0], [10, 0], [6, 4, 5]]

total_score = 0
frames.each_with_index do |frame, index|
  total_score = total_score + frame.sum
  if frame == [10, 0]
    total_score += frames[(index+1)..(index+2)].flatten.first[2].sum
    binding.irb
  elsif frame.sum == 10
    total_score += frames[index+1].flatten.first if frames[index+1] != nil
  end
end

puts total_score
