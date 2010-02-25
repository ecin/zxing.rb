#!/usr/bin/env jruby --headless -rubygems

require 'shoulda'
require File.expand_path( File.dirname(__FILE__) + '/../lib/zxing' )

class ZXingTest < Test::Unit::TestCase
  context "A QR decoder" do
    setup do
      @decoder = ZXing
      @uri = "http://2d-code.co.uk/images/bbc-logo-in-qr-code.gif"
      @path = File.expand_path( File.dirname(__FILE__) + '/qrcode.png')
      @google_logo = "http://www.google.com/logos/grandparentsday10.gif"
      @uri_result = "http://bbc.co.uk/programmes"
      @path_result = "http://rubyflow.com"
    end

    should "decode a URL" do
      assert_equal @decoder.decode(@uri), @uri_result
    end

    should "decode a file" do
      assert_equal @decoder.decode(@path), @path_result
    end

    should "return nil if #decode fails" do
      assert_nil @decoder.decode(@google_logo)
    end

    should "raise an exception if #decode! fails" do
      assert_raise(NativeException) { @decoder.decode!(@google_logo) }
    end
  end
end