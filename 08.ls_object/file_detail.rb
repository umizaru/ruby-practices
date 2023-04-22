# frozen_string_literal: true

require 'etc'

class FileDetail
  def initialize(file_name)
    @file_name = file_name
    @stat = File.stat(file_name)
  end

  def type_and_permission
    file_type_conversion_table = {
      'file' => '-',
      'dictionary' => 'd',
      'link' => 'l'
    }
    file_type = file_type_conversion_table[@stat.ftype]
    permission_number = @stat.mode.to_s(8).chars.last(3).join
    permission_symbol = permission_number.gsub(/[0-7]/, PERMISSION_CONVERSION_TABLE)
    file_type + permission_symbol
  end

  def name
    @file_name
  end

  def hardlink
    @stat.nlink.to_s
  end

  def user
    Etc.getpwuid(@stat.uid).name
  end

  def group
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def blocks
    @stat.blocks
  end

  def date_and_time
    @stat.mtime.strftime('%_m %e %H:%M')
  end

  PERMISSION_CONVERSION_TABLE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze
end
