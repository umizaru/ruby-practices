# frozen_string_literal: true

require_relative './file_detail'

class FileDetailRetriever
  def initialize(all, reverse)
    @all = all
    @reverse = reverse
  end

  def retrieve
    file_names = @all ? Dir.entries('.').sort : Dir.glob('*').sort
    file_names = files_name.reverse if @reverse
    file_names.map { |file_name| FileDetail.new(file_name) }
  end
end
