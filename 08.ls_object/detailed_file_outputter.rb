# frozen_string_literal: true

require 'debug'

class DetailedFileOutputter
  def initialize(file_details)
    @file_details = file_details
  end

  def output
    total_blocks = @file_details.sum(&:blocks)
    print "total #{total_blocks}\n"

    @file_details.each do |file_detail|
      outputs = [
        file_detail.type_and_permission,
        file_detail.hardlink.to_s.rjust(max_length_of[:hardlink] + BETWEEN_DETAILS),
        file_detail.user.to_s.ljust(max_length_of[:user] + BETWEEN_DETAILS),
        file_detail.group.to_s.ljust(max_length_of[:group] + BETWEEN_DETAILS),
        file_detail.size.to_s.rjust(max_length_of[:size]),
        file_detail.date_and_time,
        file_detail.name
      ]
      puts outputs.join(' ')
    end
  end

  private

  BETWEEN_DETAILS = 1
  private_constant :BETWEEN_DETAILS

  def max_length_of
    {
      hardlink: @file_details.map(&:hardlink).max.to_s.length,
      user: @file_details.map(&:user).max.length,
      group: @file_details.map(&:group).max.length,
      size: @file_details.map(&:size).max.to_s.length
    }
  end
end
