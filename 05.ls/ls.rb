# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'
require 'debug'

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4
Max_digits_of_size = 4
PERMISSION_PATTERNS = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

file_names = Dir.glob('*')
options = ARGV.getopts('l')

def collect_files(file_names)
  file_names.map do |file_names|
    {
      name: file_names,
      size: FileTest.size(file_names),
      stat: File.stat(file_names),
    }
  end
end

def stat_to_type_and_permission(stat)
  case stat.ftypez
  when 'file'
    file_type = '-'
  when 'directory'
    file_type = 'd'
  when 'link'
    file_type = 'l'
  end
  permission_number = stat.mode.to_s(8).split('').last(3).join('')
  permission_symbol = permission_number.gsub(/[01234567]/, PERMISSION_PATTERNS)
  type_permission = file_type + permission_symbol
end

def stat_to_hardlink(stat)
  stat.nlink
end

def stat_to_user(stat)
  Etc.getpwuid(stat.uid).name
end

def stat_to_group(stat)
  Etc.getgrgid(stat.gid).name
end

def stat_to_size(stat)
  size = stat.to_s.rjust(Max_digits_of_size)
end

def stat_to_month(stat)
  stat.atime.strftime('%m')
end

def stat_to_day(stat)
  stat.atime.strftime('%d')
end

def stat_to_minute(stat)
  stat.atime.strftime('%H:%M')
end

def print_files_detail(file)
  print "#{stat_to_type_and_permission(file[:stat])}  #{stat_to_hardlink(file[:stat])} #{stat_to_user(file[:stat])}  #{stat_to_group(file[:stat])}  #{stat_to_size(file[:size])} #{stat_to_month(file[:stat])} #{stat_to_day(file[:stat])} #{stat_to_minute(file[:stat])} #{file[:name]}"
  print "\n"
end

def options_none(file_names)
  rows = (file_names.size.to_f / NUMBER_OF_COLUMNS).ceil
  width = file_names.map(&:size).max + BETWEEN_COLUMNS
  file_names = file_names.map { |x| x.ljust(width) }
  rows.times do |i|
    puts file_names.values_at(i, i + rows, i + rows * 2).join(' ')
  end
end

def main(file_names,options)
  files = collect_files(file_names)
  if options['l']
    files.each do |file|
      print_files_detail(file)
    end
  else
    options_none(file_names)
  end
end

main(file_names,options)