# frozen_string_literal: true

class DefaultFileOutputter
  def initialize(file_details)
    @file_names = file_details.map(&:name)
  end

  def output
    number_of_rows = calc_number_of_rows
    width = calc_width + BETWEEN_COLUMNS
    formatted_details = format_file_names(width)
    output_formatted_file(number_of_rows, formatted_details)
  end

  private

  NUMBER_OF_COLUMNS = 3
  BETWEEN_COLUMNS = 5

  private_constant :NUMBER_OF_COLUMNS
  private_constant :BETWEEN_COLUMNS

  def calc_number_of_rows
    (@file_names.size.to_f / NUMBER_OF_COLUMNS).ceil
  end

  def calc_width
    @file_names.map(&:size).max
  end

  def format_file_names(width)
    @file_names.map { |file_name| file_name.ljust(width) }
  end

  def output_formatted_file(number_of_rows, formatted_details)
    number_of_rows.times do |i|
      puts formatted_details.values_at(i, i + number_of_rows, i + number_of_rows * 2).join(' ')
    end
  end
end
