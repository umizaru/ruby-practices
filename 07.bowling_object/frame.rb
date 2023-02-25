# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(shot)
    @first_shot = Shot.new(shot[0])
    @second_shot = Shot.new(shot[1])
    @third_shot = Shot.new(shot[2])
  end

  def score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    score == 10
  end

  
end
