# frozen_string_literal: true

require 'debug'
require_relative './shot'

class Frame
  def initialize(frame_shots)
    @frame_shots = frame_shots
  end

  def self.build_frames(pinfalls)
    frame_shots = []
    current_frame_shots = []
    pinfalls.each do |pinfall|
      shot = Shot.new(pinfall)
      current_frame_shots << shot
      if frame_shots.size < 9 && (current_frame_shots.size == 2 || shot.strike?)
        frame_shots << Frame.new(current_frame_shots)
        current_frame_shots = []
      end
    end
    frame_shots << Frame.new(current_frame_shots) # 10フレーム目
    binding.break
  end

  def strike?
    @frame_shots[0].strike?
  end

  def spare?
    calc_frame_score == 10 && !strike?
  end

  def first_shot_score
    @frame_shots[0].score
  end

  def second_shot_score
    @frame_shots[1].score
  end

  def calc_frame_score
    @frame_shots.map(&:score).sum
  end
end
