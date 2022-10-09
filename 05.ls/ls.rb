# frozen_string_literal: true

require 'optparse'

number_of_columns = 3

opt = ARGV.getopts('a', 'l', 'r')
array = opt.values

current_dir_files =
  if array[0].to_s == 'true'
    Dir.glob(['*', '.*'])
  else
    Dir.glob('*')
  end

number_of_files = current_dir_files.size
rows = (number_of_files.to_f / number_of_columns).ceil
rows.times do |i|
  puts current_dir_files.values_at(i, i + rows, i + rows * 2).join(' ')
end
