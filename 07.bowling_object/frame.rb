# frozen_string_literal: true

require 'debug'
require_relative './shot'

class Frame
  def initialize(frame)
    @frame_shots = frame
  end

  def self.build_frames(pinfalls)
    all_frame_shots = []
    current_frame_shots = []
    pinfalls.each do |pinfall|
      shot = Shot.new(pinfall)
      current_frame_shots << shot
      if all_frame_shots.size < 9 && (current_frame_shots.size == 2 || shot.score == 10)
        all_frame_shots << current_frame_shots
        current_frame_shots = []
      end
    end
    all_frame_shots << current_frame_shots
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
