# frozen_string_literal: true

# 下処理
require 'optparse'
require 'etc'
require 'time'
require 'debug'

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4
PERMISSION_PATTERNS = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

current_dir_files = Dir.glob('*')
current_dir_path = Dir.pwd
number_of_files = current_dir_file.size

#分岐の処理
def split_by_option(option)
  if options = ARGV.getopts('option')
    main_l
  else
    main_none
  end
end

# オプションなしの場合
def main(current_dir_files, number_of_files)
    rows = (number_of_files.to_f / NUMBER_OF_COLUMNS).ceil
    width = current_dir_files.map(&:size).max + BETWEEN_COLUMNS
    current_dir_files = current_dir_files.map { |x| x.ljust(width) }
    rows.times do |i|
      puts current_dir_files.values_at(i, i + rows, i + rows * 2).join(' ')
    end
end

# lオプションの場合
def main_l
  def total
    print 'total '
    print block.inject(:+)
    print "\n"
  end

  def all_data
    each_data.each do |n|
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
end

def file_stat(current_dir_files,current_dir_path)
  stat = []
  current_dir_files.each do |x|
  stat << File.stat("#{current_dir_path}/#{x}")
  end
  stat
end

def block(current_dir_files,current_dir_path)
  block = []
  current_dir_files.each do |x|
    block = stat.block
  end
  print 'total '
  print block.inject(:+)
  print "\n"
end

def each_data
  all_data = []
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
end

def type_and_permission(current_dir_files,current_dir_path)
  # 繰り返し処理がいるかも

  type_permission = []
  file_stats = file_stat(current_dir_files,current_dir_path)

  case file_stats.ftype
  when 'file'
    file_type = '-'
  when 'directory'
    file_type = 'd'
  when 'link'
    file_type = 'l'
  end

  permission_number = file_stats.mode.to_s(8)
  permission_number = permission_number.split('').last(3).join('')
  permission_symbol = permission_number.gsub(/[01234567]/, PERMISSION_PATTERNS)

  type_permission << file_type + permission
end

def hardlink(current_dir_files,current_dir_path)
  hardlink = []
  file_stats = file_stat(current_dir_files,current_dir_path)

  current_dir_files.each do |x|
    hardlink << file_stats.nlink
  end
end

def user(current_dir_files,current_dir_path)
  user = []
  file_stats = file_stat(current_dir_files,current_dir_path)

  user_name = Etc.getpwuid(file_stat.uid).name

  current_dir_files.each do |x|
    user << user_name
  end

  width_of_user = user.max.to_s.length
  user = user.map { |x| x.rjust(width_of_user) }

end

def group(current_dir_files,current_dir_path)
  group = []
  file_stats = file_stat(current_dir_files,current_dir_path)

  group_name = Etc.getgrgid(file_stat.gid).name

  current_dir_files.each do |x|
    group << group_name
  end

  width_of_group = group.max.to_s.length
  group = group.map { |x| x.rjust(width_of_group) }

end

def size(current_dir_files,current_dir_path)
  size = []
  file_stats = file_stat(current_dir_files,current_dir_path)

  current_dir_files.each do |x|
    hardlink << file_stats.size
  end

  width_of_size = size.max.to_s.length
  size = size.map { |x| x.to_s.rjust(width_of_size) }
end

def month_data(current_dir_files,current_dir_path)
  month_data = []
  file_stats = file_stat(current_dir_files,current_dir_path)

  file_create_time = file_stats.atime
  month_of_file_create_time = file_create_time.strftime('%m')
  month_data << month_of_file_create_time
end

def day_data(current_dir_files,current_dir_path)
  day_data = []
  file_stats = file_stat(current_dir_files,current_dir_path)

  file_create_time = file_stats.atime
  day_of_file_create_time = file_create_time.strftime('%d')
  day_data << day_of_file_create_time
end

def minute_data(current_dir_files,current_dir_path)
  minute_data = []
  file_stats = file_stat(current_dir_files,current_dir_path)

  file_create_time = file_stats.atime
  minutes_of_file_create_time = file_create_time.strftime('%H:%M')
  minute_data << minutes_of_file_create_time
end

def name(current_dir_files)
  name = []
  current_dir_files.each do |x|
  name << x.to_s
  end
end

split_by_option(option)
main_a
main_r
main_l
main_none
