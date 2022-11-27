# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l', 'w', 'c')
  files = make_source_files
  outputs = count_outputs(files)
  outputs_including_total = count_outputs_including_total(outputs)
  print_outputs(options, outputs_including_total)
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
    stdin = $stdin.read
    h = []
    h << { file_contents: stdin }
  end
end

def count_outputs(files)
  files.map do |file|
    {
      lines: count_lines(file[:file_contents]),
      words: count_words(file[:file_contents]),
      bytes: count_bytes(file[:file_contents]),
      name: (file[:file_name]).to_s
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

def count_outputs_including_total(outputs)
  if outputs.size > 1
    totals =
      {
        lines: outputs.sum { |file| file[:lines] },
        words: outputs.sum { |file| file[:words] },
        bytes: outputs.sum { |file| file[:bytes] },
        name: 'total'
      }
    outputs.push(totals)
  else
    outputs
  end
end

def print_outputs(options, outputs)
  outputs.each do |file|
    #   file.each do |key, value|
    #     file[key] = value.to_s.rjust(8) if key != :name
    # end
    print file[:lines] if options['l'] || options.values.all? { |v| v == false }
    print file[:words] if options['w'] || options.values.all? { |v| v == false }
    print file[:bytes] if options['c'] || options.values.all? { |v| v == false }
    puts " #{file[:name]}"
  end
end

main
