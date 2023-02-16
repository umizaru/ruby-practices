# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(frame)
    @first_shot = Shot.new(frame[0])
    @second_shot = Shot.new(frame[1])
    @third_shot = Shot.new(frame[2])
  end

  def score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    score == 10
    #@first_shot&.score != 10 && [@first_shot&.score,@second_shot.score].sum { _1.to_i } == 10
  end
end
