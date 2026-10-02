#!/usr/bin/env ruby
# frozen_string_literal: true

# Install smoke test for the native extension. Run it from outside the
# repository against an installed gem:
#
#   GEM_HOME=/tmp/gems GEM_PATH=/tmp/gems ruby /path/to/tools/native_smoke.rb [--binary]
#
# --binary additionally asserts that the extension came from a platform gem
# for the running Ruby ABI and that no Rust or Node toolchain is on PATH.
# Everything talks to a loopback server; no Amazon endpoint is contacted.
require "json"
require "socket"
require "stringio"
require "timeout"
require "uri"
require "zlib"

binary = ARGV.include?("--binary")

def check(condition, message)
  abort("smoke failed: #{message}") unless condition
  puts("ok  #{message}")
end

abort("run the smoke test from outside the repository") if File.exist?(File.join(Dir.pwd, "peddler.gemspec"))

if binary
  ["cargo", "rustc", "node"].each do |tool|
    check(ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).none? { |dir| File.executable?(File.join(dir, tool)) },
      "#{tool} is not on PATH")
  end
end

require "peddler"

spec = Gem.loaded_specs.fetch("peddler")
extensions = $LOADED_FEATURES.grep(/peddler_native\.(bundle|so)\z/)
check(extensions.one? && extensions.first.start_with?(Gem.dir), "extension loaded from the installed gem (#{extensions.first})")
check(spec.full_gem_path.start_with?(Gem.dir), "gem comes from GEM_HOME")
if binary
  abi = RUBY_VERSION[/\A\d+\.\d+/]
  check(spec.platform != Gem::Platform::RUBY && spec.extensions.empty?, "installed spec is a prebuilt platform gem (#{spec.platform})")
  check(spec.required_ruby_version.satisfied_by?(Gem::Version.new(RUBY_VERSION)), "gem allows this Ruby")
  match = extensions.first.match(%r{/lib/peddler/(?:(\d+\.\d+)/)?peddler_native\.(?:bundle|so)\z})
  check(match && (match[1].nil? || match[1] == abi), "binary is the Ruby #{abi} build (#{extensions.first[/lib\/peddler.*/]})")
end
check(spec.version.to_s.match?(/\A\d+\.\d+\.\d+\z/), "installed gem version is #{spec.version}")
check(!defined?(HTTP), "HTTP.rb is not loaded by peddler")

# Serves each queued handler once, in order, on a loopback port.
def serve(*handlers)
  server = TCPServer.new("127.0.0.1", 0)
  requests = []
  thread = Thread.new do
    handlers.each do |handler|
      raise "no connection" unless server.wait_readable(10)

      socket = server.accept
      Timeout.timeout(10) do
        verb, target = socket.gets("\r\n").split
        headers = {}
        while (line = socket.gets("\r\n")) != "\r\n"
          key, value = line.split(":", 2)
          headers[key.downcase] = value.strip
        end
        body = socket.read(headers.fetch("content-length", "0").to_i)
        requests << { verb: verb, target: target, headers: headers, body: body }
        handler.call(socket)
      end
    ensure
      socket&.close
    end
  end
  yield("http://127.0.0.1:#{server.addr[1]}", requests)
  thread.value
ensure
  thread&.kill
  server&.close
end

def reply(socket, status: 200, body: "{}", headers: {})
  socket.write("HTTP/1.1 #{status} X\r\n")
  headers.each { |key, value| socket.write("#{key}: #{value}\r\n") }
  socket.write("Content-Length: #{body.bytesize}\r\nConnection: close\r\n\r\n#{body}")
end

# Generated request through the Rust operation dispatcher.
serve(->(socket) { reply(socket, body: '{"asin":"B000TEST"}') }) do |url, requests|
  client = Peddler::Client.new(base_url: url, access_token: "smoke-token")
  response = client.catalog_items_2022_04_01.get_catalog_item(asin: "B000TEST", marketplace_ids: ["ATVPDKIKX0DER"])
  path, query = requests.first[:target].split("?", 2)
  check(response.status == 200 && response.json == { "asin" => "B000TEST" }, "generated operation returns the response")
  check(path == "/catalog/2022-04-01/items/B000TEST" && URI.decode_www_form(query).to_h["marketplaceIds"] == "ATVPDKIKX0DER",
    "generated operation builds the documented path and query")
  check(requests.first[:headers]["x-amz-access-token"] == "smoke-token", "access token header is sent")
end

# Managed LWA authentication.
serve(->(socket) { reply(socket, body: '{"access_token":"managed-token","expires_in":3600,"token_type":"bearer"}') }) do |lwa, lwa_requests|
  serve(->(socket) { reply(socket) }, ->(socket) { reply(socket) }) do |url, requests|
    client = Peddler::Client.new(base_url: url, client_id: "smoke-id", client_secret: "smoke-secret",
      refresh_token: "smoke-refresh", lwa_endpoint: lwa)
    2.times { client.request("GET", "/probe") }
    form = URI.decode_www_form(lwa_requests.first[:body]).to_h
    check(form["grant_type"] == "refresh_token" && form["refresh_token"] == "smoke-refresh", "LWA refresh request is well formed")
    check(requests.map { |request| request[:headers]["x-amz-access-token"] } == ["managed-token"] * 2 && lwa_requests.one?,
      "managed token is cached across requests")
  end
end

# Request policy: retry on a throttled response.
serve(->(socket) { reply(socket, status: 429, body: '{"errors":[]}', headers: { "Retry-After" => "0" }) },
  ->(socket) { reply(socket, body: '{"ok":true}') }) do |url, requests|
  client = Peddler::Client.new(base_url: url, access_token: "smoke-token", retries: 1, retry_delay: 0.01)
  response = client.request("GET", "/retry")
  check(response.status == 200 && requests.length == 2, "throttled request is retried by the Rust policy layer")
end

# Streaming document download with gzip decoding.
payload = StringIO.new
gzip = Zlib::GzipWriter.new(payload)
gzip.write(%({"n":1}\n{"n":2}\n))
gzip.close
serve(->(socket) { reply(socket, body: payload.string, headers: { "Content-Encoding" => "gzip" }) }) do |url, requests|
  client = Peddler::Client.new(base_url: url, access_token: "smoke-token")
  rows = client.download_document("#{url}/document").each_jsonl.to_a
  check(rows == [{ "n" => 1 }, { "n" => 2 }], "document stream decodes gzip JSON lines")
  check(!requests.first[:headers].key?("x-amz-access-token"), "document download does not leak the access token")
end

puts("smoke passed: ruby #{RUBY_VERSION} #{RUBY_PLATFORM} peddler #{spec.version} (#{spec.platform})")
