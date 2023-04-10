# frozen_string_literal: true

require 'debug'

class LongFilePrinter
  def initialize(details)
    @file_names = details
  end

  def identify_max_length
    {
      max_length_of_hardlink: @file_names.map(&:hardlink).max.to_s.length,
      max_length_of_user: @file_names.map(&:user).max.length,
      max_length_of_group: @file_names.map(&:group).max.length,
      max_length_of_size: @file_names.map(&:size).max.to_s.length
    }
  end

  def print_files_detail
    blocks = @file_names.sum(&:blocks)
    print "total #{blocks}\n"

    @file_names.each do |file|
      outputs = [
        file.type_and_permission,
        file.hardlink.to_s.rjust(identify_max_length[:max_length_of_hardlink]+1),
        file.user.to_s.ljust(identify_max_length[:max_length_of_user]+1),
        file.group.to_s.ljust(identify_max_length[:max_length_of_group]+1),
        file.size.to_s.rjust(identify_max_length[:max_length_of_size]),
        file.month,
        file.day,
        file.minute,
        file.name
      ]
        puts outputs.join(' ')
    end
  end
end
