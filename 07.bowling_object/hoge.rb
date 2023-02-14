# frozen_string_literal: true

require_relative './frame'
require 'debug'

# pinfalls = ["6","3","9","0","0","3","8","2","7","3","X","9","1","8","0","X","6","4","5"]
# @pinfalls = ["6","3","9","0","0","3","8","2","7","3","X","9","1","8","0","X","6","4","5"]
# frame =  [["6","3"],["9","0"],["0","3"],["8","2"],["7","3"],["X"],["9","1"],["8","0"],["X"],["6","4","5"]]

class Game
  def initialize(pinfalls)
    @pinfalls = pinfalls
  end

  def score
    frames = build_frames
    score = 0
    frames.each_with_index do |frame, index|
      frame = Frame.new(frame[0], frame[1], frame[2]).score
      following_pinfalls = @pinfalls[(index + 1)...]
      score += calc_bonus_point(frame, following_pinfalls) if frames.size < 10
    end
    binding.break
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

  def calc_bonus_point(frame, following_pinfalls)
    if frame.strike?
      following_pinfalls.first[2].sum
    elsif spare
      following_pinfalls.first
    else
      0
    end
  end
end
