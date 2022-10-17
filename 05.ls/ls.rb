# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'

options = ARGV.getopts('l')
current_dir_files = Dir.glob('*')
current_dir_pass = Dir.pwd

stat = File.stat("01.dir")

array = []

# ファイルの種類
if stat.ftype == "file"
  array << "-"
elsif stat.ftype == "directory"
  array << "d"
elsif stat.ftype == "link"
  array << "l"
end

# パーミッション
PERMISSION_PATTERN = {'0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'}.freeze
permission_number = stat.mode.to_s(8)
permission_number = permission_number.slice(3..5)
permission_pattern = permission_number.gsub(/[01234567]/,PERMISSION_PATTERN)
array <<  permission_pattern

# ハードリンクの数
array << stat.nlink

# 所有者と所有グループ
user = Etc.getpwuid(stat.uid).name
group = Etc.getgrgid(stat.gid).name
array << user
array << group

# ファイルサイズ
array <<  stat.size

# タイムスタンプ
file_create_time = stat.atime
month_of_file_create_time = file_create_time.strftime("%m")
day_of_file_create_time = file_create_time.strftime("%d")
minutes_of_file_create_time = file_create_time.strftime("%H:%M")

array << month_of_file_create_time
array << day_of_file_create_time
array << minutes_of_file_create_time

# ファイル名
array << "01.dir"

#　表示
array.each do |x|
  print x
end