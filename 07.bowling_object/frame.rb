# frozen_string_literal: true

require 'debug'
require_relative './shot'

class Frame
  def initialize(shots)
    @first_shot = Shot.new(shots[0])
    @second_shot = Shot.new(shots[1])
    @third_shot = Shot.new(shots[2])
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    calc_score == 10 && !strike?
  end

  def first_shot
    @first_shot.score
  end

  def second_shot
    @second_shot.score
  end

  def calc_score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
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
end
