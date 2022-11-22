# frozen_string_literal: true

require 'optparse'

options = ARGV.getopts('l', 'w', 'c')

def main(options)
  files = make_source_files
  print_outputs(files, options)
  return unless files.size > 1

  print_total(files, options)
end

def print_outputs(files, options)
  if options.value?(true)
    count_outputs(files).each do |file|
      print file[:lines] if options['l']
      print file[:words] if options['w']
      print file[:bytes] if options['c']
      print (file[:name]).to_s
      print "\n"
    end
  else
    count_outputs(files).each do |file|
      print file[:lines]
      print file[:words]
      print file[:bytes]
      print (file[:name]).to_s
      print "\n"
    end
  end
end

def print_total(files, options)
  totals = count_total(files)
  if options.value?(true)
    print totals[:number_of_lines] if options['l']
    print totals[:number_of_words] if options['w']
    print totals[:number_of_bytes] if options['c']
  else
    totals.each_value do |total|
      print total
    end
  end
  print ' total'
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
      lines: count_lines(file[:file_contents]).to_s.rjust(8),
      words: count_words(file[:file_contents]).to_s.rjust(8),
      bytes: count_byte(file[:file_contents]).to_s.rjust(8),
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

def count_total(files)
  {
    number_of_lines: files.sum { |file| file[:file_contents].to_s.lines.count }.to_s.rjust(8),
    number_of_words: files.sum { |file| file[:file_contents].to_s.split(/\s+/).size }.to_s.rjust(8),
    number_of_bytes: files.sum { |file| file[:file_contents].to_s.bytesize }.to_s.rjust(8)
  }
end

main(options)
