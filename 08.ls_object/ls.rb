# frozen_string_literal: true

require 'debug'
require 'optparse'
require_relative './file_outputter'

options = ARGV.getopts('a', 'l', 'r')
fileoutputter = FileOutputter.new(options)
fileoutputter.output
