# frozen_string_literal: true

require 'debug'
require_relative './frame'

class Game
  def initialize(pinfalls)
    @frames = Frame.build_frames(pinfalls)
  end

  def calc_score
    game_score = 0
    @frames.each do |frame_shots|
      frame = Frame.new(frame_shots[0], frame_shots[1], frame_shots[2])
      game_score += frame.calc_frame_score
    end
    game_score += calc_bonus_point
  end

  def calc_bonus_point
    bonus_point = 0
    @frames.each_with_index do |frame_shots, index|
      next unless index < 9

      frame = Frame.new(frame_shots[0], frame_shots[1], frame_shots[2])
      if frame.strike?
        bonus_point += calc_strike_bonus(index)
      elsif frame.spare?
        bonus_point += calc_spare_bonus(index)
      end
    end
    bonus_point
  end

  def calc_strike_bonus(index)
    next_frame = @frames[index + 1]
    next_next_frame = @frames[index + 2]
    if Frame.new(next_frame[0], next_frame[1], next_frame[2]).strike?
      if index < 8
        10 + Frame.new(next_next_frame[0], next_next_frame[1], next_next_frame[2]).first_shot_score
        # 次のフレームの1投目がストライクのとき、その次のフレームの1投目を取ってくる。
      else
        10 + Frame.new(next_frame[0], next_frame[1], next_frame[2]).second_shot_score
        # 9フレーム目がストライク＆10フレーム目の初球がストライクのとき。10点＋10フレーム目の2投目を取ってくる。
      end
    else
      Frame.new(next_frame[0], next_frame[1], next_frame[2]).first_shot_score + Frame.new(next_frame[0], next_frame[1], next_frame[2]).second_shot_score
    end
  end

  def calc_spare_bonus(index)
    next_frame = @frames[index + 1]
    Frame.new(next_frame[0], next_frame[1], next_frame[2]).first_shot_score
  end
end
