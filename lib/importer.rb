require 'csv'
require_relative 'row'

# Ingests lines from a CSV file and turns them into Row objects. 
# 
# This is the "extract" class of the ETL pipeline.
class Importer
  attr_reader :filename

  # @param filename [String] path to incoming CSV file
  def initialize(filename:)
    @filename = filename
  end

  # Returns incoming CSV file as a collection of Rows
  #
  # @return [Array<Row>]
  def import
    CSV.foreach(filename, headers: true).map { |row| Row.new(row) }
  end
end