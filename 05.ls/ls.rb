# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'

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

options = ARGV.getopts('a', 'l', 'r')
file_names = Dir.glob('*')
file_names = Dir.glob('*', File::FNM_DOTMATCH) if options['a']
file_names = file_names.reverse if options['r']

def main(file_names, options)
  files = collect_files(file_names)
  max_length = identify_max_length(files)
  if options['l']
    print_total(files)
    files.each do |file|
      print_files_detail(file, max_length)
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

def identify_max_length(files)
  {
    hardlink: files.map { |x| x[:stat].nlink }.max.to_s.length,
    user: files.map { |x| Etc.getpwuid(x[:stat].uid).name }.max.length,
    group: files.map { |x| Etc.getgrgid(x[:stat].gid).name }.max.length,
    size: files.map { |x| x[:size] }.max.to_s.length
  }
end

def type_and_permission(stat)
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

def hardlink(stat, max_length)
  stat.nlink.to_s.rjust(max_length[:hardlink])
end

def user(stat, max_length)
  Etc.getpwuid(stat.uid).name.rjust(max_length[:user])
end

def group(stat, max_length)
  Etc.getgrgid(stat.gid).name.rjust(max_length[:group])
end

def size(stat, max_length)
  stat.to_s.rjust(max_length[:size])
end

def month(stat)
  stat.atime.strftime('%_m')
end

def day(stat)
  stat.atime.strftime('%_d')
end

def minute(stat)
  stat.atime.strftime('%_H:%M')
end

def print_total(files)
  blocks = files.map do |file|
    file[:stat].blocks
  end
  print "total #{blocks.sum}\n"
end

def print_files_detail(file, max_length)
  print "#{type_and_permission(file[:stat])}  "
  print "#{hardlink(file[:stat], max_length)} "
  print "#{user(file[:stat], max_length)}  "
  print "#{group(file[:stat], max_length)}  "
  print "#{size(file[:size], max_length)} "
  print "#{month(file[:stat])} "
  print "#{day(file[:stat])} "
  print "#{minute(file[:stat])} "
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
