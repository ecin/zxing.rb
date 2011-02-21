require 'spec_helper'

def fixture_image(image)
  File.expand_path("../fixtures/#{image}.png", __FILE__)
end

describe ZXing do
  describe ".decode" do
    subject { ZXing.decode(file) }

    context "when file exists" do
      let(:file) { fixture_image("example") }
      it { should == "example" }
    end

    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it { should be_nil }
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it { should be_nil }
    end
  end

  describe ".decode!" do
    subject { ZXing.decode!(file) }

    context "with a qrcode file" do
      let(:file) { fixture_image("example") }
      it { should == "example" }
    end

    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it "raises an error" do
        expect { subject }.to raise_error(ZXing::UndecodableError, "Image not decodable")
      end
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "File nonexistentfile.png could not be found")
      end
    end
  end
end
