# frozen_string_literal: true

require 'debug'
require_relative './file_detail'

class FileDetailRetriever
  def initialize(all, reverse)
    @all = all
    @reverse = reverse
  end

  def retrieve
    files_name = @all ? Dir.entries('.').sort : Dir.glob('*')
    files_name = files_name.reverse if @reverse
    files_name.map { |file_name| FileDetail.new(file_name) }
  end
end
