require_relative "./frame.rb"

class Game
  def count_total_score
    total_score = 0
    @frames.each_with_index do |frame, index|
      total_score += frame.sum
      if frame == [10, nil]
        total_score += strike_bonus(index)
      elsif frame.sum == 10
        total_score += spare_bonus(index)
      end
    end
    total_score
  end

  private

  def strike_bonus(index)
    @frames[(index+1)..(index+2)].flatten.first[2].sum
  end

  def spare_bonus(index)
    @frames[index+1].flatten.first #flatten 入れる必要ある？
  end

end

game = Game.new
p game.count_total_score

# - スペアかどうかを判定する
# - ストライクかどうかを判定する
# - スペアのボーナスポイントをカウントする
# - ストライクのボーナスポイントをカウントする
# - すべての点数をカウントする
# - ターミナル上に総計を出力する
