# frozen_string_literal: true

require 'debug'
require_relative './file_detail'

class FileDetailGetter
  def initialize(all, reverse)
    @all = all
    @reverse = reverse
  end

  def run
    file_names = Dir.glob('*')
    file_names = Dir.glob('*', File::FNM_DOTMATCH) if @all
    file_names = file_names.reverse if @reverse
    file_details = file_names.map do |file_name|
      FileDetail.new(file_name)
    end
  end
end
