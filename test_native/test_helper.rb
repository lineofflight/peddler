# frozen_string_literal: true

require "minitest/autorun"
require "minitest/mock"
require "socket"
require "timeout"
require "json"
require "base64"
require "uri"
require "peddler"

class NativeTest < Minitest::Test
  # Without the body, a handler can answer before the client has sent it.
  def with_server(count: 1, read_body: true, &handler)
    server = TCPServer.new("127.0.0.1", 0)
    workers = []
    acceptor = Thread.new do
      count.times do
        raise "accept deadline" unless server.wait_readable(5)

        socket = server.accept
        workers << Thread.new(socket) do |connection|
          Timeout.timeout(5) do
            line = connection.gets("\r\n")
            next unless line # A failed upload can close before its head.

            first = line.split
            headers = {}
            while (line = connection.gets("\r\n")) != "\r\n"
              key, value = line.split(":", 2)
              headers[key.downcase] = value.strip
            end
            body = read_body ? connection.read(headers.fetch("content-length", "0").to_i) : nil
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

  def serve(count: 1, read_body: true, handler:)
    url, acceptor, server, workers = with_server(count: count, read_body: read_body, &handler)
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

  # Serves any number of requests on each connection, so a test can count the connections a client opens.
  # Yields the URL, the accepted sockets and the requests as [method, target, headers, body].
  def serve_keep_alive(responder: ->(*) { [200, "{}"] })
    server = TCPServer.new("127.0.0.1", 0)
    accepted = Queue.new
    requests = Queue.new
    workers = Queue.new
    acceptor = Thread.new do
      loop do
        socket = server.accept
        accepted << socket
        workers << Thread.new(socket) do |connection|
          while (line = connection.gets("\r\n"))
            method, target = line.split
            headers = {}
            while (line = connection.gets("\r\n")) != "\r\n"
              key, value = line.split(":", 2)
              headers[key.downcase] = value.strip
            end
            body = connection.read(headers.fetch("content-length", "0").to_i)
            requests << [method, target, headers, body]
            status, reply = responder.call(method, target, headers, body)
            connection.write("HTTP/1.1 #{status} Test\r\nContent-Length: #{reply.bytesize}\r\n\r\n#{reply}")
          end
        rescue IOError, SystemCallError
          nil
        end
      end
    rescue IOError, SystemCallError
      nil
    end
    yield "http://127.0.0.1:#{server.addr[1]}", accepted, requests
  ensure
    acceptor&.kill
    acceptor&.join
    workers&.close
    while (worker = workers&.pop)
      worker.kill
      worker.join
    end
    accepted&.close
    while (socket = accepted&.pop)
      socket.close
    end
    server&.close
  end

  # How the gem identifies itself to the Selling Partner API, in the form v5 sent
  def gem_user_agent
    "Peddler/#{Peddler::VERSION} (Language=Ruby; #{Socket.gethostname})"
  end

  # How it identifies itself to LWA and signed-URL hosts, which never get the host name
  def hostless_user_agent
    "Peddler/#{Peddler::VERSION} (Language=Ruby)"
  end

  # The x-amz-date form v5 sent and Amazon's connection guide shows
  AMZ_DATE = /\A\d{8}T\d{6}Z\z/

  def client(url, **options)
    Peddler::Client.new(base_url: url, access_token: "local-secret", **options)
  end
end
