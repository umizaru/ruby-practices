# frozen_string_literal: true

require 'optparse'

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4

ARGV.getopts('r')
current_dir_files = Dir.glob('*')
reverse_current_dir_files = current_dir_files.reverse

number_of_files = reverse_current_dir_files.size
rows = (number_of_files.to_f / NUMBER_OF_COLUMNS).ceil

width = reverse_current_dir_files.map(&:size).max + BETWEEN_COLUMNS
reverse_current_dir_files = reverse_current_dir_files.map { |x| x.ljust(width) }

rows.times do |i|
  puts reverse_current_dir_files.values_at(i, i + rows, i + rows * 2).join(' ')
end
