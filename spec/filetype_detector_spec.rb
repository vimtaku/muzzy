require 'spec_helper'

describe Muzzy::FiletypeDetector do
  subject {
    Muzzy::FiletypeDetector.new(filepath)
  }
  describe "tsv?" do
    context "tsv return true" do
      let(:filepath) { "spec/fixtures/partial_surround_double_quote.tsv" }
      it {
        expect(subject.tsv?).to eq true
        expect(subject.first_row).to be_a Array
        expect(subject.second_row).to be_a Array
      }
    end
    context "csv return false" do
      let(:filepath) { "spec/fixtures/partial_surround_double_quote.csv" }
      it {
        expect(subject.tsv?).to eq false
      }
    end
  end
  describe "csv?" do
    context "csv return true" do
      let(:filepath) { "spec/fixtures/partial_surround_double_quote.csv" }
      it {
        expect(subject.csv?).to eq true
        expect(subject.first_row).to be_a Array
        expect(subject.second_row).to be_a Array
      }
    end
    context "tsv return false" do
      let(:filepath) { "spec/fixtures/partial_surround_double_quote.tsv" }
      it {
        expect(subject.csv?).to eq false
      }
    end
  end
  describe "unknown?" do
  end
end
