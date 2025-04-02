require 'importer'
require 'row'

describe Importer do
  let(:filename) { "spec/fixtures/minimal.csv" }

  subject(:importer) { described_class.new(filename:) }
  
  describe "when importing data from a CSV" do
    it "returns a collection of Row objects" do
      rows = importer.import
      expect(rows.size).to eq(3)
      expect(rows.first).to be_a(Row)
      expect(rows.first.raw_data["Email"]).to eq("john@jones.com")
    end
  end
end