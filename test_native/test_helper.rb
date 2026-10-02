# frozen_string_literal: true

require "minitest/autorun"
require "socket"
require "timeout"
require "json"
require "base64"
require "uri"
require "peddler"

class NativeTest < Minitest::Test
  def with_server(count: 1, &handler)
    server = TCPServer.new("127.0.0.1", 0)
    workers = []
    acceptor = Thread.new do
      count.times do
        raise "accept deadline" unless server.wait_readable(5)

        socket = server.accept
        workers << Thread.new(socket) do |connection|
          Timeout.timeout(5) do
            first = connection.gets("\r\n").split
            headers = {}
            while (line = connection.gets("\r\n")) != "\r\n"
              key, value = line.split(":", 2)
              headers[key.downcase] = value.strip
            end
            body = connection.read(headers.fetch("content-length", "0").to_i)
            yield(connection, first, headers, body)
          end
        ensure
          connection.close
        end
      end
      workers.each(&:value)
    end
    yield_url = "http://127.0.0.1:#{server.addr[1]}"
    [yield_url, acceptor, server, workers]
  end

  def serve(count: 1, handler:)
    url, acceptor, server, workers = with_server(count: count, &handler)
    yield url
    raise "server deadline" unless acceptor.join(6)

    acceptor.value
  ensure
    acceptor&.kill
    workers&.each(&:kill)
    workers&.each(&:join)
    acceptor&.join
    server&.close
  end

  def respond(socket, status: 200, headers: [], body: "{}")
    socket.write("HTTP/1.1 #{status} Test\r\n")
    headers.each { |key, value| socket.write("#{key}: #{value}\r\n") }
    socket.write("Content-Length: #{body.bytesize}\r\nConnection: close\r\n\r\n")
    socket.write(body)
  end

  # What every request through the gem identifies itself as, in the form v5 sent
  def gem_user_agent
    "Peddler/#{Peddler::VERSION} (Language=Ruby; #{Socket.gethostname})"
  end

  # The x-amz-date form v5 sent and Amazon's connection guide shows
  AMZ_DATE = /\A\d{8}T\d{6}Z\z/

  def client(url, **options)
    Peddler::Client.new(base_url: url, access_token: "local-secret", **options)
  end
end
