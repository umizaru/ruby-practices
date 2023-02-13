require_relative "./shot.rb"

class Frame
  # shift使わないほうがいいかも？
  def divide_two_dimensions_arrays
    shots = Shot.new.convert_argument_to_array
    frames = []
    9.times do
      rolls = shots.shift(2)
      if rolls.first == 10
        frames << [rolls.first, nil]
        shots.unshift(rolls.last)
      else
        frames << rolls
      end
    end
    frames << shots
   # => [[6, 3], [9, 0], [0, 3], [8, 2], [7, 3], [10, nil], [9, 1], [8, 0], [10, nil], [6, 4, 5]]
  end
end

frames = Frame.new
p frames.divide_two_dimensions_arrays

# インスタンス変数：
# - Wakaran やりながら考える
# - メソッド：
# - フレームごとに分けて二次元配列を作る（ストライクは[10,X]にする）
