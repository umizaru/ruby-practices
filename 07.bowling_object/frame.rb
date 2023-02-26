# frozen_string_literal: true

require_relative './shot'

class Frame
  def initialize(shot)
    @first_shot = Shot.new(shot[0])
    @second_shot = Shot.new(shot[1])
    @third_shot = Shot.new(shot[2])
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    calc_score == 10 && !strike?
  end

  def self.build_frames(pinfalls)
    @frames = []
    frame = []
    pinfalls.each do |pinfall|
      frame << pinfall
      if @frames.size < 10
        if frame.size == 2 || pinfall == 'X'
          @frames << frame
          frame = []
        end
      else
        @frames.last << pinfall
      end
    end
    @frames
  end

  def calc_score
    [@first_shot.score, @second_shot.score, @third_shot.score].sum
  end

  def self.calc_bonus_point
    bonus_point = 0
    @frames.each_with_index do |frame, index|
      following_frames = @frames[index.succ..].flatten
      bonus_point += if Frame.new(frame).strike?
                       Shot.new(following_frames[0]).score + Shot.new(following_frames[1]).score
                     elsif Frame.new(frame).spare?
                       Shot.new(following_frames[0]).score
                     else
                       0
                     end
    end
    bonus_point
  end
end
