# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'
require 'debug'

PERMISSION_PATTERNS = {'0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'}.freeze

options = ARGV.getopts('l')
current_dir_files = Dir.glob('*')
current_dir_pass = Dir.pwd
@each_data_array = Array.new

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
@each_data_array << file_type + file_permission
end

# ハードリンクの数
def hardlink
  @each_data_array << @file_stat.nlink
end

# 所有者と所有グループ
def owner
  user = Etc.getpwuid(@file_stat.uid).name
  group = Etc.getgrgid(@file_stat.gid).name
  @each_data_array << user
  @each_data_array << group
end

# ファイルサイズ
def size
  @each_data_array <<  @file_stat.size
end

# タイムスタンプ
def timestamp
  file_create_time = @file_stat.atime
  month_of_file_create_time = file_create_time.strftime("%m")
  day_of_file_create_time = file_create_time.strftime("%d")
  minutes_of_file_create_time = file_create_time.strftime("%H:%M")
  @each_data_array << month_of_file_create_time
  @each_data_array << day_of_file_create_time
  @each_data_array << minutes_of_file_create_time
end

# ファイル名
def name
  @each_data_array << @file_name
end

current_dir_files.each do |x|
  @file_stat = File.stat("#{current_dir_pass}/#{x}")
  @file_name = "#{x}"
  type_and_permission
  hardlink
  owner
  size
  timestamp
  name
end

p @each_data_array