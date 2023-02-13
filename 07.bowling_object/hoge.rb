class Shot
  attr_reader :mark
  def initialize(mark)
  @mark = mark
  end
  def score
  return 10 if mark == "X"
  mark.to_i
  end
end

shot = Shot.new("9")
p shot.mark
shot.score
