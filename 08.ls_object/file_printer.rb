# frozen_string_literal: true

require 'debug'
require_relative './file_detail_getter'
require_relative './long_file_printer'
require_relative './default_file_printer'

class FilePrinter
  def initialize(options)
    @options = options
  end

  def run
    details = FileDetailGetter.new(@options['a'], @options['r']).run
    if @options['l']
      LongFilePrinter.new(details).print_files_detail
    else
      DefaultFilePrinter.new(details).print_files
    end
  end
end
