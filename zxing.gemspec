# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "zxing/version"

Gem::Specification.new do |s|
  s.name        = "zxing"
  s.version     = ZXing::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["ecin", "Joshua Davey"]
  s.email       = ["josh@joshuadavey.com"]
  s.homepage    = "http://github.com/ecin/zxing.rb"
  s.summary     = %q{Decode barcodes with ZXing java library}
  s.description = %q{JRuby wrapper for ZXing 1D/2D barcode image processing library.}

  if RUBY_PLATFORM != "java" && ENV["PLATFORM"] != "java"
    s.add_runtime_dependency "jruby-jars"
  end

  s.add_development_dependency "rspec", "~> 2.5.0"

  s.rubyforge_project = "zxing"
  s.files         = Dir.glob("{bin,lib,spec}/**/*") + %w(README.textile)
  s.test_files    = Dir.glob("spec/**/*")
  s.executables   = Dir.glob("bin/*").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
