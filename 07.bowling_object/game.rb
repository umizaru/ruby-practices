# frozen_string_literal: true

# pinfalls = ["6","3","9","0","0","3","8","2","7","3","X","9","1","8","0","X","6","4","5"]
# @pinfalls = ["6","3","9","0","0","3","8","2","7","3","X","9","1","8","0","X","6","4","5"]
# frames = [["6","3"],["9","0"],["0","3"],["8","2"],["7","3"],["X"],["9","1"],["8","0"],["X"],["6","4","5"]]
# following_pinfalls =  [["9","0"],["0","3"],["8","2"],["7","3"],["X"],["9","1"],["8","0"],["X"],["6","4","5"]]

require 'debug'
require_relative './frame'

class Game
  def initialize(pinfalls)
    @pinfalls = pinfalls
  end

  def calc_score
    game_score = 0
    pinfalls = @pinfalls
    frames = Frame.build_frames(pinfalls)
    frames.each do |frame|
      current_frame = Frame.new(frame)
      game_score += current_frame.calc_score
    end
    game_score += Frame.calc_bonus_point
  end
end
