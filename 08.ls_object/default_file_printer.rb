# frozen_string_literal: true

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4

require 'debug'

class DefaultFilePrinter
  def initialize(details)
    @file_names = details.map(&:name)
  end

  def print_files
    rows = calculate_rows
    width = calculate_width
    padded_file_names = pad_file_names(width)
    print_formatted_files(rows, padded_file_names)
  end

  private

  def calculate_rows
    (@file_names.size.to_f / NUMBER_OF_COLUMNS).ceil
  end

  def calculate_width
    @file_names.map(&:size).max + BETWEEN_COLUMNS
  end

  def pad_file_names(width)
    @file_names.map { |file_name| file_name.ljust(width) }
  end

  def print_formatted_files(rows, padded_file_names)
    rows.times do |i|
      puts padded_file_names.values_at(i, i + rows, i + rows * 2).join(' ')
    end
  end
end
