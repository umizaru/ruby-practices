# frozen_string_literal: true

BETWEEN_DETAILS = 1

class DetailedFileOutputter
  def initialize(files_detail)
    @files_detail = files_detail
  end

  def output
    total_blocks = @files_detail.sum(&:blocks)
    print "total #{total_blocks}\n"

    @files_detail.each do |file_detail|
      outputs = [
        file_detail.type_and_permission,
        file_detail.hardlink.to_s.rjust(calc_max_length[:max_length_of_hardlink] + BETWEEN_DETAILS),
        file_detail.user.to_s.ljust(calc_max_length[:max_length_of_user] + BETWEEN_DETAILS),
        file_detail.group.to_s.ljust(calc_max_length[:max_length_of_group] + BETWEEN_DETAILS),
        file_detail.size.to_s.rjust(calc_max_length[:max_length_of_size]),
        file_detail.date_and_time,
        file_detail.name
      ]
      puts outputs.join(' ')
    end
  end

  private

  def calc_max_length
    {
      max_length_of_hardlink: @files_detail.map(&:hardlink).max.to_s.length,
      max_length_of_user: @files_detail.map(&:user).max.length,
      max_length_of_group: @files_detail.map(&:group).max.length,
      max_length_of_size: @files_detail.map(&:size).max.to_s.length
    }
  end
end
