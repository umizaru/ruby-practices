# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(pinfalls)
    @frames = Frame.build_frames(pinfalls)
  end

  def calc_score
    game_score = 0
    @frames.each do |frame|
      game_score += frame.calc_score
    end
    game_score += calc_bonus_point
  end

  def calc_bonus_point
    bonus_point = 0
    @frames.each_with_index do |frame, index|
      if index < 9
        if frame.strike?
          bonus_point += calc_strike_bonus(index)
        elsif frame.spare?
          bonus_point += calc_spare_bonus(index)
        end
      end
    end
    bonus_point
  end

  def calc_strike_bonus(index)
    if @frames[index + 1].strike?
      if index < 8
        10 + @frames[index + 2].first_shot
      else
        10 + @frames[index + 1].second_shot
      end
    else
      @frames[index + 1].first_shot + @frames[index + 1].second_shot
    end
  end

  def calc_spare_bonus(index)
    @frames[index + 1].first_shot
  end
end
