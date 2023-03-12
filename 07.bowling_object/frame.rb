# frozen_string_literal: true

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
    frame = []
    pinfalls.each do |pinfall|
      shot = Shot.new(pinfall).score
      frame << shot
      if frames.size < 9 && (frame.size == 2 || shot == 10)
        frames << Frame.new(frame)
        frame = []
      end
      frames << Frame.new(frame) if frame.sum < 10 && frame.size == 2 || frame.size == 3
    end
    frames
  end
end
