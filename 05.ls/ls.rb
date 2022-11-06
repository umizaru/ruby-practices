# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'
require 'debug'

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4
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

file_names = Dir.glob('*')
options = ARGV.getopts('a','l','r')

def main(file_names, options)
  file_names = Dir.glob('*', File::FNM_DOTMATCH) if options['a']
  file_names = file_names.reverse if options['r']
  files = collect_files(file_names)
  width_of_size = shape_width(files)
  if options['l']
    files.each do |file|
      print_files_detail(file, width_of_size)
    end
  else
    print_files(file_names)
  end
end

def collect_files(file_names)
  file_names.map do |item|
    {
      name: item,
      size: FileTest.size(item),
      stat: File.stat(item)
    }
  end
end

def shape_width(files)
  size = files.map { |x| x[:size] }.max.to_s.length
end

def stat_to_type_and_permission(stat)
  case stat.ftype
  when 'file'
    file_type = '-'
  when 'directory'
    file_type = 'd'
  when 'link'
    file_type = 'l'
  end
  permission_number = stat.mode.to_s(8).split('').last(3).join('')
  permission_symbol = permission_number.gsub(/[01234567]/, PERMISSION_PATTERNS)
  file_type + permission_symbol
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

def stat_to_size(stat, width_of_size)
  stat.to_s.rjust(width_of_size)
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

def print_files_detail(file, width_of_size)
  print "#{stat_to_type_and_permission(file[:stat])}  "
  print "#{stat_to_hardlink(file[:stat])} "
  print "#{stat_to_user(file[:stat])} "
  print "#{stat_to_group(file[:stat])}  "
  print "#{stat_to_size(file[:size], width_of_size)} "
  print "#{stat_to_month(file[:stat])} "
  print "#{stat_to_day(file[:stat])} "
  print "#{stat_to_minute(file[:stat])} "
  print file[:name].to_s
  print "\n"
end

def print_files(file_names)
  rows = (file_names.size.to_f / NUMBER_OF_COLUMNS).ceil
  width = file_names.map(&:size).max + BETWEEN_COLUMNS
  file_names = file_names.map { |x| x.ljust(width) }
  rows.times do |i|
    puts file_names.values_at(i, i + rows, i + rows * 2).join(' ')
  end
end

main(file_names, options)

# block = []
# block = files[:stat].blocks
# print "total " + "#{block.inject(:+)}"