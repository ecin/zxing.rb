require 'shoulda'
require File.expand_path( File.dirname(__FILE__) + '/../lib/zxing' )

class ZXingTest < Test::Unit::TestCase
  context "A QR decoder" do
    setup do
      @decoder = ZXing
      @uri = "http://justinsomnia.org/images/qr-code-justinsomnia.png"
      @path = "qr-code-justinsomnia.png"
      @google_logo = "http://www.google.com/logos/grandparentsday10.gif"
      @code_result = "http://justinsomnia.org/"
    end

    should "decode a URL" do
      assert_equal @decoder.decode(@uri), @code_result
    end

    should "decode a file" do
      assert_equal @decoder.decode(@path), @code_result
    end

    should "return nil if #decode fails" do
      assert_nil @decoder.decode(@google_logo)
    end

    should "raise an exception if #decode! fails" do
      assert_raise(NativeException) { @decoder.decode!(@google_logo) }
    end
  end
end