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

# データ収集メソッド
def collect_file_data(current_dir_files, current_dir_path, number_of_files)
  file_data = []
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

# filestatデータを収集
def collect_type_permission_data(each_data,number_of_files)
  file_type = []
  type_permission = []
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

def collect_user_group_data(each_data,number_of_files)
  user = []
  group = []
  number_of_files.times do |n|
    user_name = Etc.getpwuid(each_data[n][:filestat].uid).name
    group_name = Etc.getgrgid(each_data[n][:filestat].gid).name
    user << user_name
    group << group_name
  end
end

def collect_other_filestat_data(each_data,number_of_files)
  hardlink = []
  month_data = []
  day_data = []
  minute_data = []
  size = []
  name = []
  number_of_files.times do |n|
    hardlink << each_data[n][:filestat].nlink
    month_data << each_data[n][:filestat].atime.strftime('%m')
    day_data << each_data[n][:filestat].atime.strftime('%d')
    minute_data << each_data[n][:filestat].atime.strftime('%H:%M')
    size << each_data[n][:filestat].size
    name << each_data[n][:file_name]
   end
end

def shape_width()
  width_of_user = user.max.to_s.length
  width_of_group = group.max.to_s.length
  width_of_size = size.max.to_s.length
  user = user.map { |x| x.rjust(width_of_user) }
  group = group.map { |x| x.rjust(width_of_group) }
  size = size.map { |x| x.to_s.rjust(width_of_size) }
end

def convert_array_hash(each_data,number_of_files)
  block = []
  hash_array = []

  number_of_files.times do |i|
  block << each_data[i][:filestat].blocks
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
  hash_array
end
end

def print_all_data
print "total #{block.inject(:+)}\n"
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
end

# lオプション
def option_l
  collect_filestat_data(each_data)
end

# オプションなし
def option_none(each_data)
  current_dir_files_name_only = []
  number_of_files.times do |i|
    current_dir_files_name_only << each_data[i][:file_name]
  end
  rows = (number_of_files.to_f / NUMBER_OF_COLUMNS).ceil
  width = current_dir_files_name_only.map(&:size).max + BETWEEN_COLUMNS
  current_dir_files_name_only = current_dir_files_name_only.map { |x| x.ljust(width) }
  rows.times do |i|
    puts current_dir_files_name_only.values_at(i, i + rows, i + rows * 2).join(' ')
  end
end

# メインメソッド
def def collect_file_data(current_dir_files, current_dir_path, number_of_files)
  if options['l']
    option_l
  else
    option_none
  end
end