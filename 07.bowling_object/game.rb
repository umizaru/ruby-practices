# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(pinfalls)
    @frames = Frame.build_frames(pinfalls)
  end

  def calc_score
    game_score = 0
    @frames.each do |frame|
      game_score += Frame.first_score(frame) + Frame.second_score(frame) + Frame.third_score(frame)
    end
    game_score += calc_bonus_point
  end

  def calc_bonus_point
    bonus_point = 0
    @frames.each_with_index do |frame, index|
      if index < 9
        if Frame.strike?(frame)
          bonus_point += calc_strike_bonus(index)
        elsif Frame.spare?(frame)
          bonus_point += calc_spare_bonus(index)
        end
      end
    end
    bonus_point
  end

  def calc_strike_bonus(index)
    if Frame.strike?(@frames[index + 1])
      if index < 8
        10 + Frame.first_score(@frames[index + 2])
      else
        10 + Frame.second_score(@frames[index + 1])
      end
    else
      Frame.first_score(@frames[index + 1]) + Frame.second_score(@frames[index + 1])
    end
  end

  def calc_spare_bonus(index)
    Frame.first_score(@frames[index + 1])
  end
end
