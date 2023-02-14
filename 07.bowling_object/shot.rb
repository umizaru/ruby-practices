# frozen_string_literal: true

class Shot
  attr_reader :pinfall

  def initialize(pinfall)
    @pinfall = pinfall
  end

  def score
    pinfall == 'X' ? 10 : pinfall.to_i
  end
end
