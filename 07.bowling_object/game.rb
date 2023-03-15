# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(pinfalls)
    @frames = Frame.build_frames(pinfalls)
  end

  def calc_score
    game_score = 0
    @frames.each do |frame|
      game_score += Frame.new(frame).calc_frame_score
    end
    game_score += calc_bonus_point
  end

  def calc_bonus_point
    bonus_point = 0
    @frames.each_with_index do |frame, index|
      if index < 9
        if Frame.new(frame).strike?
          bonus_point += calc_strike_bonus(index)
        elsif Frame.new(frame).spare?
          bonus_point += calc_spare_bonus(index)
        end
      end
    end
    bonus_point
  end

  def calc_strike_bonus(index)
    if Frame.new(@frames[index + 1]).strike?
      if index < 8
        10 + Frame.new(@frames[index + 2]).first_shot_score
      else
        10 + Frame.new(@frames[index + 1]).second_shot_score
      end
    else
      Frame.new(@frames[index + 1]).first_shot_score + Frame.new(@frames[index + 1]).second_shot_score
    end
  end

  def calc_spare_bonus(index)
    Frame.new(@frames[index + 1]).first_shot_score
  end
end
