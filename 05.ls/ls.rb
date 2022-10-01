# frozen_string_literal: true

current_dir_files = Dir.glob('*')
number_of_columns = 3
number_of_files = current_dir_files.size
data_of_rows = (number_of_files.to_f / number_of_columns).ceil

data_of_rows.times do |i|
  puts current_dir_files.values_at(i, i + data_of_rows, i + data_of_rows * 2).join(' ')
end
