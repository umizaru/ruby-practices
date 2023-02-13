require_relative "./shot.rb"

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot = nil, third_shot = nil)
      @first_shot = Shot.new(first_shot)
      @second_shot = Shot.new(second_shot)
      @third_shot = Shot.new(third_shot)
  end

  def score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?()
    @first_shot.score == 10
  end

  def spare?()
    @first_shot.score != 10 && @first_shot.score + @second_shot.score == 10 #ここ何とかならんのか
  end
end

frame = Frame.new("1","9")
p frame.score
