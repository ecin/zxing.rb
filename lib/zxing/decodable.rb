require 'zxing'

module Decodable
  def decode
    ZXing.decode(self)
  end

  def decode!
    ZXing.decode!(self)
  end

  def decode_all
    ZXing.decode_all(self)
  end

  def decode_all!
    ZXing.decode_all!(self)
  end
end