# frozen_string_literal: true

require 'optparse'
require_relative './file_outputter'

options = ARGV.getopts('a', 'l', 'r')
file_outputter = FileOutputter.new(options)
file_outputter.output
