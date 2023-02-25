# frozen_string_literal: true

require_relative './frame'

class Game
  def initialize(pinfalls)
    @pinfalls = pinfalls
  end

  def calc_score
    @frames = build_frames
    game_score = 0
    @frames.each_with_index do |frame, index|
      current_frame = Frame.new(frame)
      game_score += current_frame.score
      following_frames = @frames[index.succ..]
      game_score += calc_bonus_point(current_frame, following_frames)
    end
    game_score
  end

  def build_frames
    frames = []
    frame = []
    @pinfalls.each do |pinfall|
      frame << pinfall
      if frames.size < 10
        if frame.size == 2 || pinfall == 'X'
          frames << frame
          frame = []
        end
      else
        frames.last << pinfall
      end
    end
    frames
  end

  def calc_bonus_point(current_frame, following_frames)
    following_frames = following_frames.flatten.map { |pin| pin == 'X' ? 10 : pin.to_i }
    if current_frame.strike?
      following_frames.first(2).sum
    elsif current_frame.spare?
      following_frames.first
    else
      0
    end
  end
end
