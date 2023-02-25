# frozen_string_literal: true

# pinfalls = ["6","3","9","0","0","3","8","2","7","3","X","9","1","8","0","X","6","4","5"]
# @pinfalls = ["6","3","9","0","0","3","8","2","7","3","X","9","1","8","0","X","6","4","5"]
# @frames =  [["6","3"],["9","0"],["0","3"],["8","2"],["7","3"],["X"],["9","1"],["8","0"],["X"],["6","4","5"]]
# following_pinfalls =  [["9","0"],["0","3"],["8","2"],["7","3"],["X"],["9","1"],["8","0"],["X"],["6","4","5"]]

require_relative './shot'

class Frame
  def initialize(shot)
    @first_shot = Shot.new(shot[0])
    @second_shot = Shot.new(shot[1])
    @third_shot = Shot.new(shot[2])
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    calc_score == 10 && !strike?
  end

  def self.build_frames(pinfalls)
    frames = []
    frame = []
    pinfalls.each do |pinfall|
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

  def calc_score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def calc_bonus_point(frames)
    following_frames = frames[(frames.index(self) + 1)..].flatten
    following_frames.map { |pin| pin == 'X' ? 10 : pin.to_i }
    if strike?
      following_frames.first(2).sum
    elsif spare?
      following_frames.first
    else
      0
    end
  end

end
