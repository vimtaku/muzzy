require 'spec_helper'

describe Muzzy::Util do
  let(:filepath) { "" }
  let(:col_sep) { nil }
  describe "#fetch_header_and_first_row" do
    subject {
      Muzzy::Util.fetch_header_and_first_row(filepath, col_sep)
    }
    context "argument error" do
      context "filepath is nil" do
        let(:filepath) { nil }
        it {
          expect { subject }.to raise_error ArgumentError
        }
      end
      context "filepath not found" do
        let(:filepath) { '/path/to/notfound' }
        it {
          expect { subject }.to raise_error ArgumentError
        }
      end
    end
    context "csv" do
      let(:filepath) {
        "spec/fixtures/partial_surround_double_quote.csv"
      }
      context "valid" do
        let(:col_sep) { "," }
        it {
          expect(subject.length).to eq 2
          expect(subject[0]).not_to eq(-1)
          expect(subject[1]).not_to eq(-1)
        }
      end
      context "invalid" do
        let(:col_sep) { "\t" }
        it {
          expect(subject.length).to eq 2
          expect(subject[0]).to eq(-1)
          expect(subject[1]).to eq(-1)
        }
      end
    end
    context "tsv" do
      let(:filepath) {
        "spec/fixtures/partial_surround_double_quote.tsv"
      }
      context "valid" do
        let(:col_sep) { "\t" }
        it {
          expect(subject.length).to eq 2
          expect(subject[0]).not_to eq(-1)
          expect(subject[1]).not_to eq(-1)
        }
      end
      context "invalid" do
        let(:col_sep) { "," }
        it {
          expect(subject.length).to eq 2
          expect(subject[0]).to eq(-1)
          expect(subject[1]).to eq(-1)
        }
      end
    end
  end
end
