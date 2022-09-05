require 'optparse'
require 'debug'

numbers = ARGV[0].gsub("X","10").split(",").map(&:to_i)
score = 0
numbers.each_with_index do |item, i|
    if numbers[i] == 10
        score += numbers[i]+numbers[i+1]+numbers[i+2]
        numbers.shift(1)
    elsif numbers[i] + numbers[i+1] == 10
        score += numbers[i]+numbers[i+1]+numbers[i+2]
        numbers.shift(2)
    elsif numbers[i] + numbers[i+1] != 10
        score += numbers[i]+numbers[i+1]+numbers[i+2]
        numbers.shift(2)
    end
end
