# frozen_string_literal: true

require 'optparse'

def main
  files_with_extention = select_files_with_extension
  source_files = make_source_files(files_with_extention)
  outputs = count_outputs(source_files)
  outputs << count_total(outputs) if outputs.size > 1
  options = each_options_true_or_false
  print_outputs(outputs, options)
end

def select_files_with_extension
  ARGV.select { |file| file.include?('.') }
end

def make_source_files(files_with_extention)
  if files_with_extention.size >= 1
    files_with_extention.map do |file|
      {
        file_contents: File.read(file),
        file_name: file
      }
    end
  else
    [{ file_contents: $stdin.read }]
  end
end

def each_options_true_or_false
  options = ARGV.getopts('l', 'w', 'c')
  options = { 'l' => true, 'w' => true, 'c' => true } if options.values.none?
  options.transform_keys(&:to_sym)
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

def print_outputs(outputs, options)
  outputs.each do |file|
    print rjust(file[:lines]) if options[:l]
    print rjust(file[:words]) if options[:w]
    print rjust(file[:bytes]) if options[:c]
    puts " #{file[:name]}"
  end
end

main
