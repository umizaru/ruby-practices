# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l', 'w', 'c')
  options = { 'l' => true, 'w' => true, 'c' => true } if options.values.none?
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
    stdin_file = []
    stdin_file << { file_contents: stdin }
  end
end

def count_outputs(files)
  files.map do |file|
    {
      lines: file[:file_contents].lines.count,
      words: file[:file_contents].split(/\s+/).size,
      bytes: file[:file_contents].bytesize,
      name: file[:file_name].to_s
    }
  end
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

def print_outputs(options, outputs_including_total)
  converts = { 'l' => 'lines', 'w' => 'words', 'c' => 'bytes' }
  options = options.transform_keys { |key| converts[key] }.transform_keys(&:to_sym)
  outputs_including_total.each do |file|
    file.each_key do |item|
      print file[item].to_s.rjust(8) if options[item]
    end
    puts " #{file[:name]}"
  end
end

main
