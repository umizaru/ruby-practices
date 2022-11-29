# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('l', 'w', 'c')
  options = { 'l' => true, 'w' => true, 'c' => true } if options.values.none?
  options = options.transform_keys(&:to_sym)
  files = make_source_files
  outputs = count_outputs(files)
  if outputs.size > 1
    total = count_total(outputs)
    outputs << total
  end
  print_outputs(options, outputs)
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
    [] << { file_contents: $stdin.read }
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

def count_total(outputs)
  {
    lines: outputs.sum { |file| file[:lines] },
    words: outputs.sum { |file| file[:words] },
    bytes: outputs.sum { |file| file[:bytes] },
    name: 'total'
  }
end

def rjust(number)
  number.to_s.rjust(8)
end

def print_outputs(options, outputs)
  outputs.each do |file|
    print rjust(file[:lines]) if options[:l]
    print rjust(file[:words]) if options[:w]
    print rjust(file[:bytes]) if options[:c]
    puts " #{file[:name]}"
  end
end

main
