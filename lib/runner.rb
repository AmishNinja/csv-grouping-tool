require 'optparse'
require_relative 'importer'
require_relative 'grouper'
require_relative 'exporter'

# Coordinates the full ETL process: import rows, group rows, and export results.
class Runner
  # Runs the full ETL pipeline.
  #
  # @param file [String] the path to the input CSV file
  # @param match_type [Symbol] the grouping type: :email, :phone, or :email_or_phone
  # @return [String] the path to the output CSV file (<input_path>/prepended_<name of input file>)
  def self.run(file:, match_type:)
    raise OptionParser::MissingArgument, "Missing file" if file.nil?
    raise OptionParser::MissingArgument, "Missing matching type" if match_type.nil?

    rows = Importer.new(filename: file).import
    Grouper.new(rows, match_type).group

    outgoing = File.join(File.dirname(file), "prepended_#{File.basename(file)}")
    Exporter.new(outgoing, rows).export
    outgoing
  end
end