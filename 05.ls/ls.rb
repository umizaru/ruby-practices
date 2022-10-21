# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'

PERMISSION_PATTERNS = {'0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'}.freeze

options = ARGV.getopts('l')
@current_dir_files = Dir.glob('*')
@current_dir_pass = Dir.pwd

@type_permission_array = Array.new
@hardlink_array = Array.new
@size_array = Array.new
@name_array = Array.new
@month_data_array = Array.new
@day_data_array = Array.new
@minutes_data_array = Array.new
@user_array = Array.new
@group_array = Array.new

# ファイルのタイプとパーミッション
def type_and_permission
  if @file_stat.ftype == "file"
    file_type = "-"
  elsif @file_stat.ftype == "directory"
    file_type = "d"
  elsif @file_stat.ftype == "link"
    file_type = "l"
  end

permission_number = @file_stat.mode.to_s(8)
permission_number = permission_number.split('').last(3).join('')
file_permission = permission_number.gsub(/[01234567]/,PERMISSION_PATTERNS)
@type_permission_array << file_type + file_permission
end

# ハードリンクの数
def hardlink
  @hardlink_array << @file_stat.nlink
end

# 所有者と所有グループ
def owner
  user = Etc.getpwuid(@file_stat.uid).name
  group = Etc.getgrgid(@file_stat.gid).name
  @user_array << user
  @group_array << group
end

# ファイルサイズ
def size
  @size_array << @file_stat.size
end

# タイムスタンプ
def timestamp
  file_create_time = @file_stat.atime
  month_of_file_create_time = file_create_time.strftime("%m")
  day_of_file_create_time = file_create_time.strftime("%d")
  minutes_of_file_create_time = file_create_time.strftime("%H:%M")
  @month_data_array << month_of_file_create_time
  @day_data_array << day_of_file_create_time
  @minutes_data_array << minutes_of_file_create_time
end

# ファイル名
def name
  @name_array << @file_name
end

@current_dir_files.each do |x|
  @file_stat = File.stat("#{@current_dir_pass}/#{x}")
  @file_name = "#{x}"
  blocks
  type_and_permission
  hardlink
  owner
  size
  timestamp
  name
end

width = @user_array.max.to_s.length
@user_array = @user_array.map { |x| x.rjust(width) }

width = @group_array.max.to_s.length
@group_array = @group_array.map { |x| x.rjust(width) }

width = @size_array.max.to_s.length
@size_array = @size_array.map { |x| x.to_s.rjust(width) }

all_data_array = Array.new
i = 0
9.times {
  all_data_array <<
{
  type_permission:@type_permission_array[i],
  hardlink:@hardlink_array[i],
  user:@user_array[i],
  group:@group_array[i],
  size:@size_array[i],
  month_data:@month_data_array[i],
  day_data:@day_data_array[i],
  minutes_data:@minutes_data_array[i],
  name:@name_array[i],
}
i += 1
}

all_data_array.each do |result|
  print "#{result[:type_permission]}#{"  "}#{result[:hardlink]}#{" "}#{result[:user]}#{"  "}#{result[:group]}#{"  "}#{result[:size]}#{" "}#{result[:month_data]}#{" "}#{result[:day_data]}#{" "}#{result[:minutes_data]}#{" "}#{result[:name]}"
  print "\n"
end