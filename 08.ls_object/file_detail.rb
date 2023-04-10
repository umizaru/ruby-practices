# frozen_string_literal: true

require 'debug'

class FileDetail
  PERMISSION_PATTERNS = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(file_name)
    @file_names = file_name
    @stat = File.stat(file_name)
  end

  def type_and_permission
    case @stat.ftype
    when 'file'
      file_type = '-'
    when 'directory'
      file_type = 'd'
    when 'link'
      file_type = 'l'
    end
    permission_number = @stat.mode.to_s(8).split('').last(3).join('')
    permission_symbol = permission_number.gsub(/[01234567]/, PERMISSION_PATTERNS)
    file_type + permission_symbol
  end

  def name
    @file_names
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

  def month
    @stat.atime.strftime('%_m')
  end

  def day
    @stat.atime.strftime('%_d')
  end

  def minute
    @stat.atime.strftime('%_H:%M')
  end
end
