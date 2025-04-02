require 'grouper'
require 'importer'

describe Grouper do
  let(:groupings) { rows.map(&:group_id).uniq }

  describe "with rows from minimal.csv" do
    let(:rows) { Importer.new(filename: "spec/fixtures/minimal.csv").import }
    let(:john)  { rows[0] }
    let(:jane)  { rows[1] }
    let(:ricky) { rows[2] }

    subject(:grouper) { described_class.new(rows, matching_type) }

    context "when matching by phone" do
      let(:matching_type) { :phone }

      it "groups rows with the same phone number" do
        grouper.group
        expect(groupings).to eq(["GROUP_1", "GROUP_2"])
        expect(john.group_id).to eq(jane.group_id)
        expect(ricky.group_id).to eq("GROUP_2")
      end
    end

    context "when matching by email" do
      let(:matching_type) { :email }

      it "groups rows with the same email address" do
        grouper.group
        expect(groupings).to eq(["GROUP_1", "GROUP_2"])
        expect(jane.group_id).to eq(ricky.group_id)
        expect(john.group_id).to eq("GROUP_1")
      end
    end

    context "when matching by email or phone" do
      let(:matching_type) { :email_or_phone }

      it "groups rows with the same email OR phone number" do
        grouper.group
        expect(groupings).to eq(["GROUP_1"])
      end
    end
  end

  describe "with rows from standalone.csv" do
    let(:rows) { Importer.new(filename: "spec/fixtures/standalone.csv").import }
    let(:matching_type) { :email_or_phone }
  
    subject(:grouper) { described_class.new(rows, matching_type) }
  
    context "when rows have keys, but are standalone" do
      it "assigns a unique group to each row" do
        grouper.group
        
        expect(groupings.size).to eq(2)
        expect(groupings).to eq(["GROUP_1", "GROUP_2"])
      end
    end
  end

  describe "with rows from no_matching_keys.csv" do
    let(:rows) { Importer.new(filename: "spec/fixtures/no_matching_keys.csv").import }
    let(:matching_type) { :email_or_phone }
  
    subject(:grouper) { described_class.new(rows, matching_type) }

    context "when rows have no email or phone" do
      it "puts each unmatchable row into its own group" do
        grouper.group
        
        expect(groupings.size).to eq(2)
        expect(groupings).to eq(["GROUP_1", "GROUP_2"])
      end
    end
  end
end
