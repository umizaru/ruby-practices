class Shot
  attr_reader :mark
  def initialize(mark)
    @mark  = mark
  end

  def score
    mark == 'X' ? 10 : mark.to_i
  end
end

# - Shotクラス
#   - インスタンス変数：
#     - 倒したピンの数（0〜9の数字もしくは文字列小文字X）
#   - メソッド：
#     - 引数を受け取る
#     - 文字列"X"を数値10に変換する
