# frozen_string_literal: true

require 'optparse'

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4

options = ARGV.getopts('r')
current_dir_files = Dir.glob('*')
current_dir_files = current_dir_files.reverse if options['r']

number_of_files = current_dir_files.size
rows = (number_of_files.to_f / NUMBER_OF_COLUMNS).ceil

width = current_dir_files.map(&:size).max + BETWEEN_COLUMNS
current_dir_files = current_dir_files.map { |x| x.ljust(width) }

rows.times do |i|
  puts current_dir_files.values_at(i, i + rows, i + rows * 2).join(' ')
end
