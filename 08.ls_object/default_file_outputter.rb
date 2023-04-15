# frozen_string_literal: true

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 6

require 'debug'

class DefaultFileOutputter
  def initialize(files_detail)
    @file_name = files_detail.map(&:name)
  end

  def output
    rows = calc_rows
    width = calc_width + BETWEEN_COLUMNS
    formatted_details = format_detail(width)
    output_formatted_file(rows, formatted_details)
  end

  private

  def calc_rows
    (@file_name.size.to_f / NUMBER_OF_COLUMNS).ceil
  end

  def calc_width
    @file_name.map(&:size).max
  end

  def format_detail(width)
    @file_name.map { |file_name| file_name.ljust(width) }
  end

  def output_formatted_file(rows, formatted_details)
    rows.times do |i|
      puts formatted_details.values_at(i, i + rows, i + rows * 2).join(' ')
    end
  end
end
