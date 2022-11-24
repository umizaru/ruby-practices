# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l', 'w', 'c')
  files = make_source_files
  print_outputs(options, files)
end

def make_source_files
  if ARGV.size >= 1
    ARGV.map do |file|
      {
        file_contents: File.read(file),
        file_name: file
      }
    end
  else
    stdins = $stdin.read.split(',')
    stdins.map do |stdin|
      { file_contents: stdin }
    end
  end
end

def print_outputs(options, files)
  rjust_count_outputs_including_total(files).each do |file|
    if options.value?(true)
      print options['l'] == true ? file[:lines] : ''
      print options['w'] == true ? file[:words] : ''
      print options['c'] == true ? file[:bytes] : ''
    else
      print "#{file[:lines]}#{file[:words]}#{file[:bytes]}"
    end
    print(file[:name])
    print "\n"
  end
end

def rjust_count_outputs_including_total(files)
  count_outputs_including_total(files).each do |file|
    file.each do |key, value|
      file[key] = value.to_s.rjust(8) if key != :name
    end
  end
end

def count_outputs_including_total(files)
  outputs = count_outputs(files)
  totals =
    {
      lines: outputs.sum { |file| file[:lines] },
      words: outputs.sum { |file| file[:words] },
      bytes: outputs.sum { |file| file[:bytes] },
      name: ' total'
    }
  outputs.size > 1 ? outputs.push(totals) : outputs
end

def count_outputs(files)
  files.map do |file|
    {
      lines: count_lines(file[:file_contents]),
      words: count_words(file[:file_contents]),
      bytes: count_bytes(file[:file_contents]),
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

def count_bytes(file)
  file.bytesize
end

main
