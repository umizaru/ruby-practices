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
  maximum_number_of_characters = identify_maximum_number_of_characters(files)
  if options['l']
    print_total(files)
    files.each do |file|
      print_files_detail(file, maximum_number_of_characters)
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

def identify_maximum_number_of_characters(files)
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

def hardlink(stat, maximum_number_of_characters)
  stat.nlink.to_s.rjust(maximum_number_of_characters[:hardlink])
end

def user(stat, maximum_number_of_characters)
  Etc.getpwuid(stat.uid).name.rjust(maximum_number_of_characters[:user])
end

def group(stat, maximum_number_of_characters)
  Etc.getgrgid(stat.gid).name.rjust(maximum_number_of_characters[:group])
end

def size(stat, maximum_number_of_characters)
  stat.to_s.rjust(maximum_number_of_characters[:size])
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

def print_files_detail(file, maximum_number_of_characters)
  print "#{type_and_permission(file[:stat])}  "
  print "#{hardlink(file[:stat], maximum_number_of_characters)} "
  print "#{user(file[:stat], maximum_number_of_characters)}  "
  print "#{group(file[:stat], maximum_number_of_characters)}  "
  print "#{size(file[:size], maximum_number_of_characters)} "
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
