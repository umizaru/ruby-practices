# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(pinfalls)
    @frames = Frame.build_frames(pinfalls)
  end

  def calc_score
    game_score = 0
    @frames.each do |frame|
      game_score += frame.calc_frame_score
    end
    game_score += calc_bonus_score
  end

  def calc_bonus_score
    bonus_score = 0
    @frames.each_with_index do |frame, index|
      if index < 9
        if frame.strike?
          bonus_score += calc_strike_score(index)
        elsif frame.spare?
          bonus_score += calc_spare_score(index)
        end
      end
    end
    bonus_score
  end

  def calc_strike_score(index)
    next_frame = @frames[index + 1]
    next_next_frame = @frames[index + 2]
    if next_frame.strike?
      if index < 8
        10 + next_next_frame.first_shot_score
      else
        10 + next_frame.second_shot_score
      end
    else
      next_frame.first_shot_score + next_frame.second_shot_score
    end
  end

  def calc_spare_score(index)
    next_frame = @frames[index + 1]
    next_frame.first_shot_score
  end
end
