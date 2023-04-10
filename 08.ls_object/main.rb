# frozen_string_literal: true

require 'debug'
require 'optparse'
require_relative './file_printer'

options = ARGV.getopts('a', 'l', 'r')
print = FilePrinter.new(options)
print.run
