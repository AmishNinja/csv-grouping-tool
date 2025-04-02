require 'runner'
require 'csv'
require 'tempfile'

describe Runner, :integration do
  let(:input_file) { "spec/fixtures/minimal.csv" }
  let(:expected_uids) { ["GROUP_1", "GROUP_2"] }
  let(:match_type) { :phone }

  context "when presented with a file containing data" do
    it "ingests the file, groups rows by criteria, and outputs a file with group unique identifiers prepended" do
      Tempfile.create(['output', '.csv']) do |tempfile|
        allow(File).to receive(:join).and_return(tempfile.path)

        output_file = Runner.run(file: input_file, match_type:)

        expect(File.exist?(output_file)).to be_truthy

        output_rows = CSV.read(output_file, headers: true)
        uids = output_rows.map { |row| row[0] }.uniq

        expect(uids).to match_array(expected_uids)
      end
    end
  end

  context "when presented with an empty file" do
    it "exits early and outputs a message" do
      Tempfile.create(['empty', '.csv']) do |tempfile|
        expect {
          Runner.run(file: tempfile.path, match_type:)
        }.to output(/No rows found/).to_stdout
      end
    end
  end
end