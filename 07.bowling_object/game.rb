# frozen_string_literal: true

require 'debug'
require_relative './frame'

class Game
  def initialize(pinfalls)
    @frames = Frame.build_frames(pinfalls)
  end

  def calc_score
    game_score = 0
    @frames.each do |frame|
      current_frame = Frame.new(frame)
      game_score += current_frame.calc_frame_score
    end
    game_score += calc_bonus_point
  end

  def calc_bonus_point
    bonus_point = 0
    @frames.each_with_index do |frame, index|
      frame = Frame.new(frame)
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
    next_frame = Frame.new(@frames[index + 1])
    next_next_frame = Frame.new(@frames[index + 2])

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

  def calc_spare_bonus(index)
    next_frame = Frame.new(@frames[index + 1])
    next_frame.first_shot_score
  end
end
