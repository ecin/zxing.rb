require 'zxing/version'
require 'zxing/decoder'

module ZXing
  class UndecodableError < StandardError
    def message; "Image not decodable"; end
  end

  ##
  # Decodes barcodes from an image file
  #
  # +file+ should be the path to the image file to decode, as a string.
  #
  # Example:
  #
  #   path = "path/to/file.png"
  #   ZXing.decode(path) #=> "Encoded text"
  #
  # When the image cannot be decoded, +decode+ returns +nil+:
  #
  #   path = "./no_encoded_image.png"
  #   ZXing.decode(path) #=> nil
  #
  def self.decode(file)
    Decoder.decode(file)
  end

  ##
  # Same as +decode+, but raises an exception when image cannot be decoded.
  #
  # +file+ should be the path to the image file to decode, as a string.
  #
  # Example:
  #
  #   path = "./no_encoded_image.png"
  #   ZXing.decode(path) #=> ZXing::UndecodableError
  #
  def self.decode!(file)
    Decoder.decode!(file)
  end
end
