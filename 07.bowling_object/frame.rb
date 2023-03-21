# frozen_string_literal: true

require 'debug'
require_relative './shot'

class Frame
  def initialize(first_shot, second_shot = nil, third_shot = nil)
    @first_shot = first_shot
    @second_shot = second_shot
    @third_shot = third_shot
    @shots = []
    @shots << first_shot
    @shots << second_shot if second_shot
    @shots << third_shot if third_shot
  end

  def self.build_frames(pinfalls)
    frames = []
    current_frame_shots = []
    pinfalls.each do |pinfall|
      shot = Shot.new(pinfall)
      current_frame_shots << shot
      if frames.size < 9 && (current_frame_shots.size == 2 || shot.score == 10)
        frames << current_frame_shots
        current_frame_shots = []
      end
    end
    frames << current_frame_shots
  end

  def strike?
    @first_shot.strike?
  end

  def spare?
    calc_frame_score == 10 && !strike?
  end

  def first_shot_score
    @first_shot.score
  end

  def second_shot_score
    @second_shot.score
  end

  def calc_frame_score
    # [@first_shot.score,@second_shot.score,@third_shot.score].sum
    frame_score = 0
    @shots.each do |shot|
      frame_score += shot.score
    end
    frame_score
  end
end
