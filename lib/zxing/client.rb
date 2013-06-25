require 'socket'
require 'drb'

module ZXing
  BIN = File.expand_path('../../../bin/zxing', __FILE__)

  class Client
    def self.new
      port = ENV['ZXING_PORT'] || find_available_port
      setup_drb_server(port) unless ENV['ZXING_PORT'] && responsive?(port)
      DRbObject.new_with_uri("druby://127.0.0.1:#{port}")
    end

    private

    def self.setup_drb_server(port)
      remote_client = IO.popen("#{ZXing::BIN} #{port}")
      sleep 0.5 until responsive?(port)
      at_exit { Process.kill(:INT, remote_client.pid) }
    end

    def self.responsive?(port)
      socket = TCPSocket.open('127.0.0.1', port)
      true
    rescue Errno::ECONNREFUSED
      false
    ensure
      socket.close if socket
    end

    def self.find_available_port
      server = TCPServer.new('127.0.0.1', 0)
      server.addr[1]
    ensure
      server.close if server
    end
  end
end
