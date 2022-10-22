# frozen_string_literal: true

# 下処理１
require 'optparse'
require 'etc'
require 'time'
require 'debug'

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4
PERMISSION_PATTERNS = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

file_stat = []
file_name = []
file_type = []
block = []
type_permission = []
hardlink = []
size = []
name = []
month_data = []
day_data = []
minutes_data = []
user = []
group = []
all_data = []

# 下処理②
current_dir_files = Dir.glob('*')
current_dir_pass = Dir.pwd
number_of_files = current_dir_files.size

current_dir_files.each do |x|
  file_stat << File.stat("#{current_dir_pass}/#{x}")
  file_name << x.to_s
end

# lオプションの各属性の処理
def block(block,file_stat)
    block << file_stat.blocks
end

def type_and_permission(type_permission,file_stat)
  case file_stat.ftype
  when 'file'
    file_type = '-'
  when 'directory'
    file_type = 'd'
  when 'link'
    file_type = 'l'
  end

  permission_number = file_stat.mode.to_s(8)
  permission_number = permission_number.split('').last(3).join('')
  permission_symbol = permission_number.gsub(/[01234567]/, PERMISSION_PATTERNS)
  type_permission << file_type + permission
end

def hardlink(hardlink,file_stat)
  hardlink << file_stat.nlink
end

def owner(user,group,file_stat)
  user_name = Etc.getpwuid(file_stat.uid).name
  group_name = Etc.getgrgid(file_stat.gid).name
  user << user_name
  group << group_name
end

def size(size,file_stat)
  size << file_stat.size
end

def timestamp(month_data,day_data,minutes_data,file_stat)
  file_create_time = file_stat.atime
  month_of_file_create_time = file_create_time.strftime('%m')
  day_of_file_create_time = file_create_time.strftime('%d')
  minutes_of_file_create_time = file_create_time.strftime('%H:%M')
  month_data << month_of_file_create_time
  day_data << day_of_file_create_time
  minutes_data << minutes_of_file_create_time
end

def name(name,file_name)
  name << file_name
end

def width(user,group,size)
width_of_user = user.max.to_s.length
user = user.map { |x| x.rjust(width_of_user) }

width_of_group = group.max.to_s.length
group= group.map { |x| x.rjust(width_of_group) }

width_of_size = size.max.to_s.length
size = size.map { |x| x.to_s.rjust(width_of_size) }

number_of_files.times |i|
  all_data <<
    {
      type_permission: type_permission[i],
      hardlink: hardlink[i],
      user: user[i],
      group: group[i],
      size: size[i],
      month_data: month_data[i],
      day_data: day_data[i],
      minutes_data: minutes_data[i],
      name: name[i]
    }

# オプションで分岐させる
def entered_options(option)
  if options = ARGV.getopts('option')
    output_option_l
  else
    output_option_none
  end
end

# オプションなしの場合
def output_option_none(current_dir_files, number_of_files)
    rows = (number_of_files.to_f / NUMBER_OF_COLUMNS).ceil

  width = current_dir_files.map(&:size).max + BETWEEN_COLUMNS
  current_dir_files = current_dir_files.map { |x| x.ljust(width) }

  rows.times do |i|
    puts current_dir_files.values_at(i, i + rows, i + rows * 2).join(' ')
  end
end

# lオプションの場合
def output_option_l
  print 'total '
  print block.inject(:+)
  print "\n"

  all_data.each do |n|
    print "#{n[:type_permission]}  "
    print "#{n[:hardlink]} "
    print "#{n[:user]}  "
    print "#{n[:group]}  "
    print "#{n[:size]} "
    print "#{n[:month_data]} "
    print "#{n[:day_data]} "
    print "#{n[:minutes_data]} "
    print (n[:name]).to_s
    print "\n"
  end
end

# メソッドを実行
