require 'runner'
require 'csv'
require 'fileutils'

describe Runner, :integration do
  let(:input_file) { "spec/fixtures/minimal.csv" }
  let(:expected_uids) { ["GROUP_1", "GROUP_2"] }

  it "ingests a file, groups rows by criteria, and outputs a file with group unique identifiers prepended" do
    Tempfile.create(['output', '.csv']) do |tempfile|
      allow(File).to receive(:join).and_return(tempfile.path)

      output_file = Runner.run(file: input_file, match_type: :phone)

      expect(File.exist?(output_file)).to be(true)

      output_rows = CSV.read(output_file, headers: true)
      uids = output_rows.map { |row| row[0] }.uniq

      expect(uids).to match_array(expected_uids)
    end
  end
end