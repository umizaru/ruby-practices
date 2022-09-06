require 'optparse'
numbers = ARGV[0].gsub('X', '10').split(',').map(&:to_i)
score = 0
10.times do
  if numbers[0] == 10
    score += numbers[0] + numbers[1] + numbers[2]
    numbers.shift(1)
  elsif numbers[0] + numbers[1] == 10
    score += numbers[0] + numbers[1] + numbers[2]
    numbers.shift(2)
  elsif numbers[0] + numbers[1] != 10
    score += numbers[0] + numbers[1]
    numbers.shift(2)
  end
end
puts score
