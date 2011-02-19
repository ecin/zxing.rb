require 'spec_helper'

describe ZXing do
  describe ".decode" do
    let(:file) { File.expand_path('../fixtures/example.png', __FILE__) }
    it "decodes png files" do
      ZXing.decode(file).should == "example"
    end
  end
end
