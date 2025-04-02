require 'csv'

# Exports Row objects and includes their group identifiers.
# 
# This is the "load" class of the ETL pipeline.
class Exporter
  attr_reader :filename, :rows

  # @param filename [String] path to outgoing CSV file
  # @param rows [Array<Row>] rows to be exported 
  def initialize(filename, rows)
    @filename = filename
    @rows = rows
  end

  # Writes the CSV file with a prepended group identifier column and the original row data.
  # 
  # @return [void]
  def export
    CSV.open(filename, 'w') do |csv|
      csv << ["group_id"] + rows.first.raw_data.headers
      rows.each { |row| csv << row.to_csv_line }
    end
  end
end