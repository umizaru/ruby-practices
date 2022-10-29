# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'

NUMBER_OF_COLUMNS = 3
BETWEEN_COLUMNS = 4
PERMISSION_PATTERNS = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

current_dir_files = Dir.glob('*')
current_dir_path = Dir.pwd
number_of_files = current_dir_files.size
options = ARGV.getopts('l')

# データを収集、整理するメソッド
def collect_file_data(current_dir_files, current_dir_path,number_of_files)
  file_name = []
  size = []
  filestat = []
  hoge_data = []

  current_dir_files.each do |x|
    file_name << x.to_s
    size << FileTest.size?(x.to_s)
    filestat << File.stat("#{current_dir_path}/#{x}")
  end

  number_of_files.times do |i|
    hoge_data <<
      {
        file_name: file_name[i],
        size: size[i],
        filestat: filestat[i]
      }
  end
end

file_data =  collect_file_data(current_dir_files, current_dir_path,number_of_files)

# lオプション
def option_l(file_data)
  file_data.each do |n|
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

def main_l(current_dir_files, current_dir_path)
  total(current_dir_files, current_dir_path)
  all_data(current_dir_files, current_dir_path)
end


def type_permission(current_dir_files, current_dir_path)
  type_permission = []
  file_stats = []
  current_dir_files.each do |x|
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
    type_permission << file_type + permission_symbol
  end
  type_permission
end

def hardlink(current_dir_files, current_dir_path)
  hardlink = []
  file_stats = []
  current_dir_files.each do |x|
    file_stats = File.stat("#{current_dir_path}/#{x}")
    hardlink << file_stats.nlink
  end
  hardlink
end

def user(current_dir_files, current_dir_path)
  user = []
  file_stats = []
  current_dir_files.each do |x|
    file_stats = File.stat("#{current_dir_path}/#{x}")
    user_name = Etc.getpwuid(file_stats.uid).name
    user << user_name
  end
  width_of_user = user.max.to_s.length
  user = user.map { |x| x.rjust(width_of_user) }
end

def group(current_dir_files, current_dir_path)
  group = []
  file_stats = []
  current_dir_files.each do |x|
    file_stats = File.stat("#{current_dir_path}/#{x}")
    group_name = Etc.getgrgid(file_stats.gid).name
    group << group_name
  end
  width_of_group = group.max.to_s.length
  group = group.map { |x| x.rjust(width_of_group) }
end

def month_data(current_dir_files, current_dir_path)
  month_data = []
  file_stats = []
  current_dir_files.each do |x|
    file_stats = File.stat("#{current_dir_path}/#{x}")
    file_create_time = file_stats.atime
    month_of_file_create_time = file_create_time.strftime('%m')
    month_data << month_of_file_create_time
  end
  month_data
end

def day_data(current_dir_files, current_dir_path)
  day_data = []
  file_stats = []
  current_dir_files.each do |x|
    file_stats = File.stat("#{current_dir_path}/#{x}")
    file_create_time = file_stats.atime
    day_of_file_create_time = file_create_time.strftime('%d')
    day_data << day_of_file_create_time
  end
  day_data
end

def minute_data(current_dir_files, current_dir_path)
  minute_data = []
  file_stats = []
  current_dir_files.each do |x|
    file_stats = File.stat("#{current_dir_path}/#{x}")
    file_create_time = file_stats.atime
    minutes_of_file_create_time = file_create_time.strftime('%H:%M')
    minute_data << minutes_of_file_create_time
  end
  minute_data
end


def total(current_dir_files, current_dir_path)
  block = []
  current_dir_files.each do |x|
    block << File.stat("#{current_dir_path}/#{x}").blocks
  end
  print 'total '
  print block.inject(:+)
  print "\n"
end

def main_l(current_dir_files, current_dir_path)
  total(current_dir_files, current_dir_path)
  all_data(current_dir_files, current_dir_path)
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
