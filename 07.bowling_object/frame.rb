# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(frame)
    @frame = frame
    @first_shot = frame[0]
    @second_shot = frame[1]
    @third_shot = frame[2]
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
    frame_score = 0
    @frame.each do |shot|
      frame_score += shot.score
    end
    frame_score
  end
end
