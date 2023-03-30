# frozen_string_literal: true

require_relative './game'

pinfalls = ARGV[0].split(',')
game = Game.new(pinfalls)
puts game.calc_score
