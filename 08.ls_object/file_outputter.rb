# frozen_string_literal: true

require 'debug'
require_relative './file_detail_retriever'
require_relative './long_file_outputter'
require_relative './default_file_outputter'

class FileOutputter
  def initialize(options)
    @options = options
  end

  def output
    files_detail = FileDetailRetriever.new(@options['a'], @options['r']).retrieve
    if @options['l']
      LongFileOutputter.new(files_detail).output
    else
      DefaultFileOutputter.new(files_detail).output
    end
  end
end
