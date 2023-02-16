require './bowling'
require 'test/unit'

class BowlingTest < Test::Unit::TestCase
  def test_calc_1
    assert_equal 139, calc_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5')
  end

  def test_calc_2
    assert_equal 164, calc_score('6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X')
  end

  def test_calc_3
    assert_equal 107, calc_score('0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4')
  end

  def test_calc_all_zero
    assert_equal 0, calc_score('0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0')
  end

  def test_calc_perfect
    assert_equal 300, calc_score('X,X,X,X,X,X,X,X,X,X,X,X')
  end
end
