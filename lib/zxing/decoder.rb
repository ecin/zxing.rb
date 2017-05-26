require 'uri'

module ZXing
  if RUBY_PLATFORM != 'java'
    require 'zxing/client'
    Decoder = Client.new
  else
    require 'java'
    require 'zxing/core-3.3.0.jar'
    require 'zxing/javase-3.3.0.jar'

    java_import com.google.zxing.MultiFormatReader
    java_import com.google.zxing.qrcode.QRCodeReader
    java_import com.google.zxing.BinaryBitmap
    java_import com.google.zxing.Binarizer
    java_import com.google.zxing.common.GlobalHistogramBinarizer
    java_import com.google.zxing.common.HybridBinarizer
    java_import com.google.zxing.LuminanceSource
    java_import com.google.zxing.client.j2se.BufferedImageLuminanceSource
    java_import com.google.zxing.multi.GenericMultipleBarcodeReader

    java_import javax.imageio.ImageIO
    java_import java.net.URL

    class Decoder
      attr_accessor :file

      def self.decode!(file)
        new(file).decode
      rescue NativeException
        raise UndecodableError
      end

      def self.decode(file)
        decode!(file)
      rescue UndecodableError
        nil
      end

      def self.decode_all!(file)
        new(file).decode_all
      rescue NativeException
        raise UndecodableError
      end

      def self.decode_all(file)
        decode_all!(file)
      rescue UndecodableError
        []
      end

      def self.qrcode_decode(file)
        new(file).qrcode_decode
      end

      def initialize(file)
        self.file = file
      end

      def reader
        MultiFormatReader.new
      end

      def decode
        reader.decode(bitmap).to_s
      end

      def qrcode_decode
        result = qr_decode(bitmap)
        return result if result
        qr_decode(hybird_bitmap)
      end

      def decode_all
        multi_barcode_reader = GenericMultipleBarcodeReader.new(reader)

        multi_barcode_reader.decode_multiple(bitmap).map do |result|
          result.get_text
        end
      end

      private

      def bitmap
        BinaryBitmap.new(binarizer)
      end

      def image
        ImageIO.read(io)
      end

      def io
        if file =~ URI.regexp(['http', 'https'])
          URL.new(file)
        else
          raise ArgumentError, "File #{file} could not be found" unless File.exist?(file)
          Java::JavaIO::File.new(file)
        end
      end

      def luminance
        BufferedImageLuminanceSource.new(image)
      end

      def binarizer
        GlobalHistogramBinarizer.new(luminance)
      end

      def hybrid_binarizer
        HybridBinarizer.new(luminance)
      end

      def hybird_bitmap
        BinaryBitmap.new(hybrid_binarizer)
      end

      def qr_decode(bitmap)
        qrcode_reader.decode(bitmap).to_s
      rescue NativeException
        nil
      end

      def qrcode_reader
        @qrcode_reader ||= QRCodeReader.new
      end
    end
  end
end
