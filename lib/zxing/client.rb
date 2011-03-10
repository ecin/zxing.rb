require 'socket'
require 'drb'

module ZXing
  BIN = File.expand_path('../../../bin/zxing', __FILE__)

  class Client
    def self.new
      port = find_available_port
      remote_client = IO.popen("#{ZXing::BIN} #{port}")

      sleep 0.5 until responsive?(port)

      at_exit { Process.kill(:INT, remote_client.pid) }
      client = DRbObject.new_with_uri("druby://127.0.0.1:#{port}")
      client
    end

    private
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
