# Run this in jruby only
if RUBY_PLATFORM == 'java'
  lib = File.expand_path('../..', __FILE__)
  $:.unshift(lib) unless $:.include?(lib)

  require 'zxing'
  require 'zxing/decoder'
  require 'drb/drb'

  module ZXing
    class Server
      def self.start!(port)
        abort_on_parent_exit!
        DRb.start_service("druby://127.0.0.1:#{port}", Decoder)
        DRb.thread.join
      end

      private
      def self.abort_on_parent_exit!
        Thread.new(Thread.current) do |parent|
          loop {
            exit unless parent.alive?
            sleep 0.5
          }
        end
      end
    end
  end
end
