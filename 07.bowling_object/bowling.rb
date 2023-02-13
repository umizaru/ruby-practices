require_relative './game.rb'

shots = ARGV[0].split(',')
game = Game.new(shots)
puts game.score
