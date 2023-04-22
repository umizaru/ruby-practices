# frozen_string_literal: true

require 'optparse'
require_relative './file_outputter'

options = ARGV.getopts('a', 'l', 'r')
fileoutputter = FileOutputter.new(options)
fileoutputter.output
