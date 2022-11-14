# frozen_string_literal: true

require 'optparse'
options = ARGV.getopts('l', 'w', 'c')

def main(options)
  files = make_source_files
  print_outputs(files, options)
  print_total(files, options)
end

def make_source_files
  if ARGV.size >= 1
    collect_files
  else
    stdins = $stdin.read.split(',')
    stdins.map do |i|
      {
        file_contents: i
      }
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

def print_outputs(files, options)
  if options.value?(true)
    files.each do |file|
      print_outputs_options(file, options)
    end
  else
    files.each do |file|
      print_outputs_options_none(file)
    end
  end
end

def print_outputs_options(file, options)
  print count_number_of_lines(file[:file_contents]).to_s.rjust(8) if options['l']
  print count_number_of_words(file[:file_contents]).to_s.rjust(8) if options['w']
  print count_bytesize(file[:file_contents]).to_s.rjust(8) if options['c']
  print " #{file[:file_name]}"
  print "\n"
end

def print_outputs_options_none(file)
  print count_number_of_lines(file[:file_contents]).to_s.rjust(8)
  print count_number_of_words(file[:file_contents]).to_s.rjust(8)
  print count_bytesize(file[:file_contents]).to_s.rjust(8)
  print " #{file[:file_name]}"
  print "\n"
end

def count_number_of_lines(file)
  file.lines.count
end

def count_number_of_words(file)
  file.split(/\s+/).size
end

def count_bytesize(file)
  file.bytesize
end

def print_total(files, options)
  return unless files.size > 1

  if options.value?(true)
    print_total_options(files, options)
  else
    print_total_options_none(files)
  end
end

def print_total_options(files, options)
  print count_total(files)[:number_of_lines].to_s.rjust(8) if options['l']
  print count_total(files)[:number_of_words].to_s.rjust(8) if options['w']
  print count_total(files)[:number_of_bytes].to_s.rjust(8) if options['c']
  print ' total'
end

def print_total_options_none(files)
  print count_total(files)[:number_of_lines].to_s.rjust(8)
  print count_total(files)[:number_of_words].to_s.rjust(8)
  print count_total(files)[:number_of_bytes].to_s.rjust(8)
  print ' total'
end

def count_total(files)
  {
    number_of_lines: files.map { |x| x[:file_contents].to_s.lines.count }.sum,
    number_of_words: files.map { |x| x[:file_contents].to_s.split(/\s+/).size }.sum,
    number_of_bytes: files.map { |x| x[:file_contents].to_s.bytesize }.sum
  }
end

main(options)
