# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4
PERMISSION_PATTERNS = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze
NUMBER_OF_FILESTAT = 9

@options = ARGV.getopts('l')

def entered_options
  if @options['l']
    output_option_l
  else
    output_option_none
  end
end

# オプションなしの場合
def output_option_none
  current_dir_files = Dir.glob('*')

  number_of_files = current_dir_files.size
  rows = (number_of_files.to_f / NUMBER_OF_COLUMNS).ceil

  width = current_dir_files.map(&:size).max + BETWEEN_COLUMNS
  current_dir_files = current_dir_files.map { |x| x.ljust(width) }

  rows.times do |i|
    puts current_dir_files.values_at(i, i + rows, i + rows * 2).join(' ')
  end
end

@current_dir_files = Dir.glob('*')
@current_dir_pass = Dir.pwd

@block_array = []
@type_permission_array = []
@hardlink_array = []
@size_array = []
@name_array = []
@month_data_array = []
@day_data_array = []
@minutes_data_array = []
@user_array = []
@group_array = []
@all_data_array = []

# ブロック数
def block
  @block_array << @file_stat.blocks
end

# ファイルのタイプとパーミッション
def type_and_permission
  case @file_stat.ftype
  when 'file'
    file_type = '-'
  when 'directory'
    file_type = 'd'
  when 'link'
    file_type = 'l'
  end

  permission_number = @file_stat.mode.to_s(8)
  permission_number = permission_number.split('').last(3).join('')
  file_permission = permission_number.gsub(/[01234567]/, PERMISSION_PATTERNS)
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
  month_of_file_create_time = file_create_time.strftime('%m')
  day_of_file_create_time = file_create_time.strftime('%d')
  minutes_of_file_create_time = file_create_time.strftime('%H:%M')
  @month_data_array << month_of_file_create_time
  @day_data_array << day_of_file_create_time
  @minutes_data_array << minutes_of_file_create_time
end

# ファイル名
def name
  @name_array << @file_name
end

# 各要素で配列を作成
@current_dir_files.each do |x|
  @file_stat = File.stat("#{@current_dir_pass}/#{x}")
  @file_name = x.to_s
  block
  type_and_permission
  hardlink
  owner
  size
  timestamp
  name
end

# ファイル名の長さ
width = @user_array.max.to_s.length
@user_array = @user_array.map { |x| x.rjust(width) }

width = @group_array.max.to_s.length
@group_array = @group_array.map { |x| x.rjust(width) }

width = @size_array.max.to_s.length
@size_array = @size_array.map { |x| x.to_s.rjust(width) }

# すべての要素を含む配列を作成
i = 0
NUMBER_OF_FILESTAT.times do
  @all_data_array <<
    {
      type_permission: @type_permission_array[i],
      hardlink: @hardlink_array[i],
      user: @user_array[i],
      group: @group_array[i],
      size: @size_array[i],
      month_data: @month_data_array[i],
      day_data: @day_data_array[i],
      minutes_data: @minutes_data_array[i],
      name: @name_array[i]
    }
  i += 1
end

# 文字列として出力
def output_option_l
  print 'total '
  print @block_array.inject(:+)
  print "\n"

  @all_data_array.each do |n|
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

entered_options
