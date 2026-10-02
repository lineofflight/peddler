# frozen_string_literal: true

# Local synthetic transfer. Both server and sink contribute to process RSS.
require "socket"
require "zlib"
require "peddler"

megabytes = Integer(ARGV.fetch(0, "128"))
mode = ARGV.fetch(1, "raw")
raise ArgumentError, "mode must be raw or gzip" unless ["raw", "gzip"].include?(mode)

total = megabytes * 1024 * 1024
server = TCPServer.new("127.0.0.1", 0)
url = "http://127.0.0.1:#{server.addr[1]}"
worker = Thread.new do
  connection = server.accept
  connection.gets("\r\n")
  loop { break if connection.gets("\r\n") == "\r\n" } # Bounded headers only.
  connection.write("HTTP/1.1 200 OK\r\nTransfer-Encoding: chunked\r\nConnection: close\r\n")
  connection.write("Content-Encoding: gzip\r\n") if mode == "gzip"
  connection.write("\r\n")
  send_chunk = lambda do |bytes|
    unless bytes.empty?
      connection.write("#{bytes.bytesize.to_s(16)}\r\n")
      connection.write(bytes)
      connection.write("\r\n")
    end
  end
  compressor = Zlib::Deflate.new(Zlib::DEFAULT_COMPRESSION, Zlib::MAX_WBITS + 16) if mode == "gzip"
  block = "x" * (64 * 1024)
  remaining = total
  while remaining.positive?
    bytes = remaining >= block.bytesize ? block : block.byteslice(0, remaining)
    send_chunk.call(compressor ? compressor.deflate(bytes) : bytes)
    remaining -= bytes.bytesize
  end
  send_chunk.call(compressor.finish) if compressor
  compressor&.close
  connection.write("0\r\n\r\n")
ensure
  connection&.close
end

client = Peddler::Client.new(base_url: url, access_token: "local-secret")
start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
consumed = 0
client.download_document(url, timeout: 120).each_chunk { |bytes| consumed += bytes.bytesize }
worker.value
server.close
raise "incorrect byte count" unless consumed == total

puts "mode=#{mode} bytes=#{consumed} elapsed=#{(Process.clock_gettime(Process::CLOCK_MONOTONIC) - start).round(3)}"
