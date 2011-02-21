require 'zxing/version'
require 'zxing/decoder'

module ZXing
  class UndecodableError < StandardError
    def message; "Image not decodable"; end
  end

  def self.decode(file)
    Decoder.decode(file)
  end

  def self.decode!(file)
    Decoder.decode!(file)
  end
end
