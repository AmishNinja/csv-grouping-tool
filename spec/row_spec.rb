require 'row'
require 'csv'

describe Row do
  let(:header_row) { ["firstName","Email1","Email2","Phone1","Phone2"].freeze }
  let(:single_row) { ["JohnZipline","a@A.com", "B@b.com", "(001) 123-4567","111.222|3333"].freeze }
  let(:csv_row) { CSV::Row.new(header_row, single_row) }
  
  subject(:row) { described_class.new(csv_row) }

  context "when matching keys" do
    it "returns normalized phone numbers" do
      expect(row.match_keys(:phone)).to eq(
        ["0011234567", "1112223333"]
      )
    end

    it "returns normalized email addresses" do
      expect(row.match_keys(:email)).to eq(
        ["a@a.com", "b@b.com"]
      )
    end

    it "returns normalized phone numbers and email addresses" do
      expect(row.match_keys(:email_or_phone)).to eq(
        ["a@a.com", "b@b.com", "0011234567", "1112223333"]
      )
    end
  end

  context "when outputting to csv" do
    it "includes the group unique identifier of the row" do
      row.group_id = "GROUP_1"
      expect(row.to_csv_line).to eq(
        ["GROUP_1", "JohnZipline", "a@A.com", "B@b.com", "(001) 123-4567", "111.222|3333"]
      )
    end
  end
end