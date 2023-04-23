# frozen_string_literal: true

require_relative './file_detail_retriever'
require_relative './detailed_file_outputter'
require_relative './default_file_outputter'

class FileOutputter
  def initialize(options)
    @options = options
  end

  def output
    file_details = FileDetailRetriever.new(@options['a'], @options['r']).retrieve
    if @options['l']
      DetailedFileOutputter.new(file_details).output
    else
      DefaultFileOutputter.new(file_details).output
    end
  end
end
