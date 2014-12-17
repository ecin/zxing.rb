require 'spec_helper'
require 'zxing'

class Foo
  def path
    File.expand_path("../fixtures/example.png", __FILE__)
  end
end

describe ZXing do
  describe ".decode" do
    subject { ZXing.decode(file, hints) }
    let(:hints) { nil }

    context "with a string path to image" do
      let(:file) { fixture_image("example") }
      it { should == "example" }
    end

    context "with a uri" do
      let(:file) { "http://2d-code.co.uk/images/bbc-logo-in-qr-code.gif" }
      it { should == "http://bbc.co.uk/programmes" }
    end

    context "with an instance of File" do
      let(:file) { File.new(fixture_image("example")) }
      it { should == "example" }
    end

    context "with an object that responds to #path" do
      let(:file) { Foo.new }
      it { should == "example" }
    end

    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it { should be_nil }
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "File nonexistentfile.png could not be found")
      end
    end

    context "when hints/try_harder is not set should find 1D codes first" do
      let(:file) { fixture_image("another_example") }
      it { should == "1D_test"}
    end

    context "when hints/try_harder is set should find QR code first" do
      let(:file) { fixture_image("another_example") }
      let(:hints) { {:try_harder => true} }
      it { should == "QR_test"}
    end

    context "when hints provided include an invalid choice" do
      let(:file) { fixture_image("example") }
      let(:hints) { {:invalid_choice => true} }
      it "raise an error" do
        expect { subject }.to raise_error(StandardError)
      end
    end

    context "when hints possible_formats specifies format of code on image" do
      let(:file) { fixture_image("example") }
      let(:hints) { {:possible_formats => ["QR_CODE"] } }
      it { should == "example" }
    end

    context "when hints possible_formats specifies format other than code on image" do
      let(:file) { fixture_image("example") }
      let(:hints) { {:possible_formats => ["CODE_128"] } }
      it "should return nil" do
        should == nil
      end
    end

    context "when hints possible_formats is not an array" do
      let(:file) { fixture_image("example") }
      let(:hints) { {:possible_formats => "CODE_128" } }
      it "raise an error" do
        expect { subject }.to raise_error(StandardError)
      end
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

    context "when the image cannot be decoded from a URL" do
      let(:file) { "http://www.google.com/logos/grandparentsday10.gif" }
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

  describe ".decode_all" do
    subject { ZXing.decode_all(file) }

    context "with a single barcoded image" do
      let(:file) { fixture_image("example") }
      it { should == ["example"] }
    end

    context "with a multiple barcoded image" do
      let(:file) {fixture_image("multi_barcode_example") }
      it { should == ['test456','test123']}
    end

    context "when the image cannot be decoded" do
      let(:file) { fixture_image("cat") }
      it { should == [] }
    end

    context "when file does not exist" do
      let(:file) { 'nonexistentfile.png' }
      it "raises an error" do
        expect { subject }.to raise_error(ArgumentError, "File nonexistentfile.png could not be found")
      end
    end

  end

  describe ".decode_all!" do
    subject { ZXing.decode_all!(file) }

    context "with a single barcoded image" do
      let(:file) { fixture_image("example") }
      it { should == ["example"] }
    end

    context "with a multiple barcoded image" do
      let(:file) {fixture_image("multi_barcode_example") }
      it { should == ['test456','test123']}
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
