require 'uri'

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
    java_import com.google.zxing.DecodeHintType
    java_import java.util.Hashtable
    java_import com.google.zxing.Binarizer
    java_import com.google.zxing.common.GlobalHistogramBinarizer
    java_import com.google.zxing.LuminanceSource
    java_import com.google.zxing.client.j2se.BufferedImageLuminanceSource
    java_import com.google.zxing.multi.GenericMultipleBarcodeReader

    java_import javax.imageio.ImageIO
    java_import java.net.URL

    class Decoder
      attr_accessor :file

      def self.decode!(file, hints=nil)
        new(file).decode(hints)
      rescue NativeException
        raise UndecodableError
      end

      def self.decode(file, hints=nil)
        decode!(file, hints)
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

      def initialize(file)
        self.file = file
      end

      def reader
        MultiFormatReader.new
      end

      def get_hint_hashtable(hints)
        # Create HashTable to pass to #decode as the second parameter.
        ht = Hashtable.new
        hints.each do |hint,value|
          case hint
          when :try_harder
            ht.put(DecodeHintType::TRY_HARDER, value)
          when :character_set
            ht.put(DecodeHintType::CHARACTER_SET, value)
          when :allowed_lengths
            ht.put(DecodeHintType::ALLOWED_LENGTHS, value)
          when :pure_barcode
            ht.put(DecodeHintType::PURE_BARCODE, value)
          when :assume_code_39_check_digit
            ht.put(DecodeHintType::ASSUME_CODE_39_CHECK_DIGIT, value)
          when :need_result_point_callback
            ht.put(DecodeHintType::NEED_RESULT_POINT_CALLBACK, value)
          when :possible_formats
            ht.put(DecodeHintType::POSSIBLE_FORMATS, value)
          else
            raise StandardError, "'#{hint}' is not a valid DecodeHintType"
          end
        end
        ht
      end

      def decode(hints=nil)
       if hints
          reader.decode(bitmap, get_hint_hashtable(hints)).to_s
        else
          reader.decode(bitmap)
        end
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
    end
  end
end
