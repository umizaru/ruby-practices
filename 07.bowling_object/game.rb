# frozen_string_literal: true

require_relative './frame'

class Game
  attr_reader :pinfalls

  def initialize(pinfalls)
    @pinfalls = pinfalls
  end

  def calc_score
    game_score = 0
    frames = Frame.build_frames(pinfalls)
    frames.each do |frame|
      current_frame = Frame.new(frame)
      game_score += current_frame.calc_score
    end
    game_score += Frame.calc_bonus_point
  end
end
