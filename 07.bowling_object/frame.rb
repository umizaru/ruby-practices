# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(shots)
    @shots = shots
  end

  def self.build_frames(pinfalls)
    frames = []
    current_shots = []
    pinfalls.each do |pinfall|
      shot = Shot.new(pinfall)
      current_shots << shot
      if frames.size < 9 && (current_shots.size == 2 || shot.strike?)
        frames << Frame.new(current_shots)
        current_shots = []
      end
    end
    frames << Frame.new(current_shots) # 10フレーム目
  end

  def strike?
    @shots[0].strike?
  end

  def spare?
    calc_frame_score == 10 && !strike?
  end

  def first_shot_score
    @shots[0].score
  end

  def second_shot_score
    @shots[1].score
  end

  def calc_frame_score
    @shots.map(&:score).sum
  end
end
