# frozen_string_literal: true

require 'debug'
require_relative './shot'

class Frame
  def self.first_score(frame)
    frame[0].score
  end

  def self.second_score(frame)
    frame[1].nil? ? 0 : frame[1].score
  end

  def self.third_score(frame)
    frame[2].nil? ? 0 : frame[2].score
  end

  def self.strike?(frame)
    frame[0].score == 10
  end

  def self.spare?(frame)
    frame[0].score + frame[1].score == 10
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
