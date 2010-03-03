require File.expand_path( File.dirname(__FILE__) + '/../zxing')

module Decodable

  def decode
    ZXing.decode(self.path)
  end

end
