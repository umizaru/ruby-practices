# frozen_string_literal: true

require 'debug'

current_dir_files = Dir.glob('*') # 全ファイル配列
rows = 3 # 列数
number_of_files = current_dir_files.size # ファイル数
columns = (number_of_files.to_f / rows).ceil # 行数

display_array = []

columns.times do |i|
  display_array << current_dir_files.values_at(i, i + columns, i + columns * 2)
end

display_array.map do |n|
  puts n.join(' ')
end
