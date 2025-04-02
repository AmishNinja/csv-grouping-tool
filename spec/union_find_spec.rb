require 'union_find'
require 'importer'

describe UnionFind do
  let(:rows) { Importer.new(filename: "spec/fixtures/minimal.csv").import }
  let(:john)  { rows[0] }
  let(:jane)  { rows[1] }
  let(:ricky) { rows[2] }

  subject(:union_find) { described_class.new }

  context "when finding the object's root" do
    it "returns the object if it is its own parent" do
      union_find.find(john)

      expect(union_find.find(john)).to eq(john)
    end

    it "returns the object's parent" do
      union_find.find(john)
      union_find.union(john, jane)
      union_find.union(jane, ricky)

      expect(union_find.find(ricky)).to eq(john)
    end
  end

  context "when unionizing objects" do
    it "links two objects together into the same set" do
      union_find.union(john, jane)

      expect(union_find.find(john)).to eq(union_find.find(jane))
    end
  end

  context "when grouping objects by their root" do
    it "groups objects into a single set" do
      union_find.union(john, jane)
      union_find.union(jane, ricky)

      groups = union_find.groups
      
      expect(groups.size).to eq(1)
      expect(groups.first).to contain_exactly(john, jane, ricky)
    end

    it "groups objects into multiple sets" do
      union_find.union(john, jane) # joined
      union_find.find(ricky) # solo

      groups = union_find.groups

      expect(groups.size).to eq(2)
      expect(groups).to include(match_array([john, jane]))
      expect(groups).to include([ricky])
    end
  end
end