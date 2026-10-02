# frozen_string_literal: true

require "socket"
require "uri"
require "yaml"
require_relative "../../tools/export_native_fixtures"

# Serves the responses recorded in a VCR cassette over a loopback server.
#
# The native HTTP client can't be intercepted in process, so tests point a client's base_url here instead. A request
# is answered by the first unused interaction with the same method, path and query. Anything else gets a 501, which
# fails the test through the raised error.
class Replay
  ROOT = File.expand_path("../..", __dir__)

  attr_reader :url

  def initialize(cassette)
    path = File.join(ROOT, "test/vcr_cassettes", "#{cassette}.yml")
    @interactions = YAML.safe_load_file(path).fetch("http_interactions").reject do |interaction|
      URI(interaction.fetch("request").fetch("uri")).path == "/auth/o2/token"
    end
    @mutex = Mutex.new
    @server = TCPServer.new("127.0.0.1", 0)
    @url = "http://127.0.0.1:#{@server.addr[1]}"
    @acceptor = Thread.new { accept }
  end

  def stop
    @acceptor.kill
    @acceptor.join
    @server.close
  end

  private

  def accept
    loop do
      socket = @server.accept
      begin
        serve(socket)
      ensure
        socket.close
      end
    end
  end

  def serve(socket)
    verb, target = socket.gets("\r\n").split
    length = 0
    while (line = socket.gets("\r\n")) != "\r\n"
      name, value = line.split(":", 2)
      length = value.to_i if name.casecmp?("content-length")
    end
    socket.read(length)
    interaction = take(verb, target)
    return respond(socket, 501, [], "no recorded interaction for #{verb} #{target}") unless interaction

    response = interaction.fetch("response")
    headers = response.fetch("headers").flat_map do |name, values|
      NativeFixtures::RESPONSE_HEADERS.include?(name.downcase) ? values.map { |value| [name, value] } : []
    end
    respond(socket, response.fetch("status").fetch("code"), headers, NativeFixtures.body_bytes(response.fetch("body")))
  end

  def take(verb, target)
    @mutex.synchronize do
      index = @interactions.index do |interaction|
        request = interaction.fetch("request")
        request.fetch("method").casecmp?(verb) && signature(request.fetch("uri")) == signature(target)
      end
      @interactions.delete_at(index) if index
    end
  end

  # v5 recorded every array as one comma-joined value. The native client repeats the parameter where the spec says
  # so, which is the same list on the wire.
  def signature(uri)
    parsed = URI(uri)
    pairs = URI.decode_www_form(parsed.query || "").flat_map { |name, value| value.split(",", -1).map { |part| [name, part] } }
    [parsed.path, pairs.sort]
  end

  def respond(socket, status, headers, body)
    socket.write("HTTP/1.1 #{status} Replay\r\n")
    headers.each { |name, value| socket.write("#{name}: #{value}\r\n") }
    socket.write("Content-Length: #{body.bytesize}\r\nConnection: close\r\n\r\n")
    socket.write(body)
  end
end
