# frozen_string_literal: true

require 'optparse'
require 'debug'

options = ARGV.getopts('l', 'w', 'c')

def main
  files = make_source_files
  print_outputs(files)
  return unless files.size > 1
  print_total(files)
end

def make_source_files
  if ARGV.size >= 1
    collect_files
  else
    stdins = $stdin.read.split(',')
    stdins.map do |i|
      { file_contents: i }
    end
  end
end

def collect_files
  ARGV.map do |file|
    {
      file_contents: File.read(file),
      file_name: File.open(file).path
    }
  end
end

def count_outputs(files)
  files.map do |file|
    {
      lines: count_lines(file[:file_contents]),
      words: count_words(file[:file_contents]),
      bytes: count_byte(file[:file_contents]),
      name: " #{file[:file_name]}"
    }
  end
end

def count_lines(file)
  file.lines.count
end

def count_words(file)
  file.split(/\s+/).size
end

def count_byte(file)
  file.bytesize
end

def print_outputs(files)
  options = ARGV.getopts('l', 'w', 'c')
  count_outputs(files).each do |file|
    file.each_value do |f|
      print f.to_s.rjust(8)
    end
    print "\n"
  end
end

def count_total(files)
  {
    number_of_lines: files.sum { |file| file[:file_contents].to_s.lines.count },
    number_of_words: files.sum { |file| file[:file_contents].to_s.split(/\s+/).size },
    number_of_bytes: files.sum { |file| file[:file_contents].to_s.bytesize }
  }
end

def print_total(files)
  count_total(files).each_value do |file|
    print file.to_s.rjust(8)
  end
  print ' total'
end

main
