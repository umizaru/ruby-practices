# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'
require 'debug'

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4
PERMISSION_PATTERNS = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

current_dir_files = Dir.glob('*')
current_dir_path = Dir.pwd
number_of_files = current_dir_files.size
options = ARGV.getopts('l')
file_data = []

# データを収集、整理するメソッド
def collect_file_data(current_dir_files, current_dir_path,number_of_files)
  file_name = []
  size = []
  filestat = []
  all_data = []

  current_dir_files.each do |x|
    file_name << x.to_s
    size << FileTest.size?(x.to_s)
    filestat << File.stat("#{current_dir_path}/#{x}")
  end

  number_of_files.times do |i|
    all_data <<
      {
        file_name: file_name[i],
        size: size[i],
        filestat: filestat[i]
      }
  end
  all_data
end

each_data = collect_file_data(current_dir_files, current_dir_path, number_of_files)

# lオプション
hardlink = []
month_data = []
day_data = []
minute_data = []
name = []
file_type = []
type_permission = []
user = []
group = []
size = []
hash_array = []
block = []

number_of_files.times do |n|
case each_data[n][:filestat].ftype
  when 'file'
    file_type = '-'
  when 'directory'
    file_type = 'd'
  when 'link'
    file_type = 'l'
  end
  permission_number = each_data[n][:filestat].mode.to_s(8)
  permission_number = permission_number.split('').last(3).join('')
  permission_symbol = permission_number.gsub(/[01234567]/, PERMISSION_PATTERNS)
  type_permission << file_type + permission_symbol
end

number_of_files.times do |n|
  user_name = Etc.getpwuid(each_data[n][:filestat].uid).name
  group_name = Etc.getgrgid(each_data[n][:filestat].gid).name
  user << user_name
  group << group_name
end

number_of_files.times do |n|
  hardlink << each_data[n][:filestat].nlink
  month_data << each_data[n][:filestat].atime.strftime('%m')
  day_data << each_data[n][:filestat].atime.strftime('%d')
  minute_data << each_data[n][:filestat].atime.strftime('%H:%M')
  size << each_data[n][:filestat].size
  name << each_data[n][:file_name]
end

width_of_user = user.max.to_s.length
width_of_group = group.max.to_s.length
width_of_size = size.max.to_s.length

user = user.map { |x| x.rjust(width_of_user) }
group = group.map { |x| x.rjust(width_of_group) }
size = size.map { |x| x.to_s.rjust(width_of_size) }

number_of_files.times do |i|
  block << each_data[n][:filestat].blocks
  hash_array <<
  {
    type_permission: type_permission[i],
    hardlink: hardlink[i],
    user: user[i],
    group: group[i],
    size: size[i],
    month_data: month_data[i],
    day_data: day_data[i],
    minute_data: minute_data[i],
    name: name[i]
  }
end

print 'total ' + "#{block.inject(:+)}"
hash_array.each do |n|
  print "#{n[:type_permission]}  "
  print "#{n[:hardlink]} "
  print "#{n[:user]}  "
  print "#{n[:group]}  "
  print "#{n[:size]} "
  print "#{n[:month_data]} "
  print "#{n[:day_data]} "
  print "#{n[:minute_data]} "
  print (n[:name]).to_s
  print "\n"
end

def main_none(current_dir_files, number_of_files)
  rows = (number_of_files.to_f / NUMBER_OF_COLUMNS).ceil
  width = current_dir_files.map(&:size).max + BETWEEN_COLUMNS
  current_dir_files = current_dir_files.map { |x| x.ljust(width) }
  rows.times do |i|
    puts current_dir_files.values_at(i, i + rows, i + rows * 2).join(' ')
  end
end

if options['l']
  main_l(current_dir_files, current_dir_path)
else
  main_none(current_dir_files, number_of_files)
end