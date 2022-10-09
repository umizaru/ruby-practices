# frozen_string_literal: true

require 'optparse'

number_of_columns = 3
between_columns = 4

argument = ARGV.getopts('a')

current_dir_files =
  if argument['a']
    Dir.glob(['.*', '*'])
  else
    Dir.glob('*')
  end

number_of_files = current_dir_files.size
rows = (number_of_files.to_f / number_of_columns).ceil

width = current_dir_files.map(&:size).max + between_columns
current_dir_files = current_dir_files.map { |x| x.ljust(width) }

rows.times do |i|
  puts current_dir_files.values_at(i, i + rows, i + rows * 2).join(' ')
end
