require 'spec_helper'
require 'zxing/decodable'

describe Decodable do
  class Object::File
    include Decodable
  end
  
  class URL
    include Decodable
    attr_reader :path
    def initialize(path)
      @path = path
    end
  end
  
  before(:all) do
    @file = File.new fixture_image('example')
    @uri = URL.new 'http://2d-code.co.uk/images/bbc-logo-in-qr-code.gif'
    @bad_uri = URL.new 'http://google.com'
  end
  
  it "provides #decode to decode the return value of #path" do
    @file.decode.should == ZXing.decode(@file.path)
    @uri.decode.should  == ZXing.decode(@uri.path)
    @bad_uri.decode.should be_nil
  end

  it "provides #decode! as well" do
    @file.decode!.should == ZXing.decode(@file.path)
    @uri.decode!.should  == ZXing.decode(@uri.path)
    expect { @bad_uri.decode! }.to raise_error(ZXing::UndecodableError, "Image not decodable")
  end
end