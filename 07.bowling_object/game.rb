# frozen_string_literal: true

require_relative './frame'

# pinfalls = ["6","3","9","0","0","3","8","2","7","3","X","9","1","8","0","X","6","4","5"]
# @pinfalls = ["6","3","9","0","0","3","8","2","7","3","X","9","1","8","0","X","6","4","5"]
# @frames =  [["6","3"],["9","0"],["0","3"],["8","2"],["7","3"],["X"],["9","1"],["8","0"],["X"],["6","4","5"]]
# following_pinfalls =  [["9","0"],["0","3"],["8","2"],["7","3"],["X"],["9","1"],["8","0"],["X"],["6","4","5"]]

class Game
  def initialize(pinfalls)
    @pinfalls = pinfalls
  end

  def score
    @frames = build_frames
    score = 0
    10.times do |index|
      frame = Frame.new(@frames[index])
      score += frame.score
      following_pinfalls = @frames[index.succ..]
      score += calc_bonus_point(frame, following_pinfalls)
    end
    score
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
    following_pinfalls = following_pinfalls.flatten.map { |pin| pin == 'X' ? 10 : pin.to_i }
    if frame.strike?
      following_pinfalls.first(2).sum
      elsif frame.spare?
      following_pinfalls.first
    else
      0
    end
  end
end
