# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'
require 'debug'

PERMISSION_PATTERN = {'0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'}.freeze

options = ARGV.getopts('l')
current_dir_files = Dir.glob('*')
current_dir_pass = Dir.pwd
@each_data_array = Array.new

# ファイルの種類
def type
  if @file_stat.ftype == "file"
    @each_data_array << "-"
  elsif @file_stat.ftype == "directory"
    @each_data_array << "d"
  elsif @file_stat.ftype == "link"
    @each_data_array << "l"
  end
end

# パーミッション
def permission
  permission_number = @file_stat.mode.to_s(8).slice(3..5)
  @each_data_array << permission_number.gsub(/[01234567]/,PERMISSION_PATTERN)
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
  @each_data_array << "x"
end

current_dir_files.each do |x|
  @file_stat = File.stat("#{current_dir_pass}/#{x}")
  type
  permission
  hardlink
  owner
  size
  timestamp
  name
end

p @each_data_array
