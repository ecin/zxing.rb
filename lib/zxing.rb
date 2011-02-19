require 'zxing/decoder'

module ZXing
  def self.decode(file)
    Decoder.decode(file)
  end
end
