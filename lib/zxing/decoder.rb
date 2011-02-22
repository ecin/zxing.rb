module ZXing
  if RUBY_PLATFORM != 'java'
    require 'zxing/client'
    Decoder = Client.new
  else
    require 'java'
    require 'zxing/core.jar'
    require 'zxing/javase.jar'

    java_import com.google.zxing.MultiFormatReader
    java_import com.google.zxing.BinaryBitmap
    java_import com.google.zxing.Binarizer
    java_import com.google.zxing.common.GlobalHistogramBinarizer
    java_import com.google.zxing.LuminanceSource
    java_import com.google.zxing.client.j2se.BufferedImageLuminanceSource

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

      def initialize(file)
        self.file = file
      end

      def decode
        MultiFormatReader.new.decode(bitmap).to_s
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
    end
  end
end
