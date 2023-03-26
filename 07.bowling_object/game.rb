# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(pinfalls)
    @all_frame_shots = Frame.build_frames(pinfalls)
  end

  def calc_score
    game_score = 0
    @all_frame_shots.each do |frame_shots|
      game_score += frame_shots.calc_frame_score
    end
    game_score += calc_bonus_point
  end

  def calc_bonus_point
    bonus_point = 0
    @all_frame_shots.each_with_index do |frame_shots, index|
      if index < 9
        if frame_shots.strike?
          bonus_point += calc_strike_bonus(index)
        elsif frame_shots.spare?
          bonus_point += calc_spare_bonus(index)
        end
      end
    end
    bonus_point
  end

  def calc_strike_bonus(index)
    next_frame_shots = @all_frame_shots[index + 1]
    next_next_frame_shots = @all_frame_shots[index + 2]
    if next_frame_shots.strike?
      if index < 8
        10 + next_next_frame_shots.first_shot_score
      else
        10 + next_frame_shots.second_shot_score
      end
    else
      next_frame_shots.first_shot_score + next_frame_shots.second_shot_score
    end
  end

  def calc_spare_bonus(index)
    next_frame_shots = @all_frame_shots[index + 1]
    next_frame_shots.first_shot_score
  end
end
