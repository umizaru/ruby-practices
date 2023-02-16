following_pinfalls = [["9","0"],["0","3"],["8","2"],["7","3"],["X"],["9","1"],["8","0"],["X"],["6","4","5"]]
p following_pinfalls = following_pinfalls.flatten.map { |pin| pin == 'X' ? 10 : pin.to_i }
p following_pinfalls.first(2).sum
