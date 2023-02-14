# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(frame)
    @first_shot = Shot.new(frame[0])
    @second_shot = Shot.new(frame[1])
    @third_shot = Shot.new(frame[2])
  end

  def score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    @first_shot.score != 10 && @first_shot.score + @second_shot.score == 10 # ここ何とかならんのか
  end
end

# p Frame.new(["6","3"]).score
