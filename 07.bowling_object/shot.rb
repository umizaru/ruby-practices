# frozen_string_literal: true

class Shot
  def initialize(pinfall)
    @pinfall = pinfall
  end

  def score
    @pinfall == 'X' ? 10 : @pinfall.to_i
  end

  def strike?
    @pinfall == 'X'
  end
end
