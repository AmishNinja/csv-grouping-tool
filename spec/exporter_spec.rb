require 'exporter'
require 'importer'
require 'tempfile'

describe Exporter do
  let(:rows) { Importer.new(filename: "spec/fixtures/standalone.csv").import }
  let(:alice) { rows[0] }
  let(:bob) { rows[1] }

  context "when exporting data" do
    it "writes each row with its group unique identifier prepended to an output file" do
      Tempfile.create(["export_test", ".csv"]) do |tempfile|
        filename = tempfile.path
        alice.group_id = "GROUP_1"
        bob.group_id = "GROUP_2"

        Exporter.new(filename, rows).export

        output_csv = File.readlines(filename).map(&:strip)

        expect(output_csv).to eq([
          "group_id,firstName,lastName,Phone,Email,zip",
          "GROUP_1,alice,alice,123-4567,a@a.com,",
          "GROUP_2,bob,bob,234-5678,b@b.com,"
        ])
      end
    end
  end
end