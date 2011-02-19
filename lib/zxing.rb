require 'zxing/decoder'

module ZXing
  extend self

  def decode(file)
    Decoder.new(file).decode
  end
end
