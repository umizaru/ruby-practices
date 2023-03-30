# frozen_string_literal: true

require 'test/unit'
require_relative './game'

class GameTest < Test::Unit::TestCase
  def setup
    @game1 = Game.new(%w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X 6 4 5])
    @game2 = Game.new(%w[6 3 9 0 0 3 8 2 7 3 X 9 1 8 0 X X X X])
    @game3 = Game.new(%w[0 10 1 5 0 0 0 0 X X X 5 1 8 1 0 4])
    @game4 = Game.new(%w[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0])
    @game5 = Game.new(%w[X X X X X X X X X X X X])
  end

  def test_calc_score1
    assert_equal(139, @game1.calc_score)
  end

  def test_calc_score2
    assert_equal(164, @game2.calc_score)
  end

  def test_calc_score3
    assert_equal(107, @game3.calc_score)
  end

  def test_calc_score4
    assert_equal(0, @game4.calc_score)
  end

  def test_calc_score5
    assert_equal(300, @game5.calc_score)
  end
end
