require 'spec_helper'

describe Muzzy::HeaderDetector do
  let(:first_row) { '' }
  let(:second_row) { '' }
  subject {
    Muzzy::HeaderDetector.detect([first_row, second_row])
  }
  describe "#detect" do
  end
end
