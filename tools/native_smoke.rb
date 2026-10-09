#!/usr/bin/env ruby
# frozen_string_literal: true

# Install smoke test for the native extension. Run it from outside the
# repository against an installed gem:
#
#   GEM_HOME=/tmp/gems GEM_PATH=/tmp/gems ruby /path/to/tools/native_smoke.rb [--binary]
#
# --binary additionally asserts that the extension came from a platform gem
# for the running Ruby ABI and that no Rust toolchain is on PATH.
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
  ["cargo", "rustc"].each do |tool|
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
# Any version RubyGems takes, a prerelease such as 6.0.0.pre.1 included.
check(Gem::Version.correct?(Peddler::VERSION) && spec.version == Gem::Version.new(Peddler::VERSION),
  "installed gem version is #{spec.version}")
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
  response = client.catalog_items_2022_04_01.get_catalog_item("B000TEST", ["ATVPDKIKX0DER"])
  path, query = requests.first[:target].split("?", 2)
  check(response.status == 200 && response.to_h == { "asin" => "B000TEST" }, "generated operation returns the response")
  check(path == "/catalog/2022-04-01/items/B000TEST" && URI.decode_www_form(query).to_h["marketplaceIds"] == "ATVPDKIKX0DER",
    "generated operation builds the documented path and query")
  check(requests.first[:headers]["x-amz-access-token"] == "smoke-token", "access token header is sent")
end

# Login with Amazon: one request for a token, which the client then sends as given.
serve(->(socket) { reply(socket, body: '{"access_token":"fresh-token","expires_in":3600,"token_type":"bearer"}') }) do |lwa, lwa_requests|
  tokens = Peddler::LWA.new(client_id: "smoke-id", client_secret: "smoke-secret", lwa_endpoint: lwa)
    .refresh(refresh_token: "smoke-refresh")
  form = URI.decode_www_form(lwa_requests.first[:body]).to_h
  check(form["grant_type"] == "refresh_token" && form["refresh_token"] == "smoke-refresh", "LWA refresh request is well formed")
  serve(->(socket) { reply(socket) }, ->(socket) { reply(socket) }) do |url, requests|
    client = Peddler::Client.new(base_url: url, access_token: tokens.access_token)
    client.request("GET", "/probe")
    client.with_access_token("other-token").request("GET", "/probe")
    check(requests.map { |request| request[:headers]["x-amz-access-token"] } == ["fresh-token", "other-token"],
      "the client sends the token it is given, and a view sends its own")
  end
end

# Request policy: retry on a throttled response.
serve(->(socket) { reply(socket, status: 429, body: '{"errors":[]}', headers: { "Retry-After" => "0" }) },
  ->(socket) { reply(socket, body: '{"ok":true}') }) do |url, requests|
  client = Peddler::Client.new(base_url: url, access_token: "smoke-token", retries: 1)
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

# A Ractor other than the main one: the extension has to say it is safe there, or Ruby refuses every call.
serve(->(socket) { reply(socket, body: '{"ractor":true}') }) do |url, requests|
  Warning[:experimental] = false
  ractor = Ractor.new(url) do |base|
    Peddler::Client.new(base_url: base, access_token: "ractor-token").request("GET", "/ractor").to_h
  end
  waiter = Thread.new { ractor.respond_to?(:value) ? ractor.value : ractor.take }
  check(waiter.join(10) && waiter.value == { "ractor" => true }, "a Ractor makes a request with a client of its own")
  check(requests.first[:headers]["x-amz-access-token"] == "ractor-token", "the Ractor's client sends its token")
end

puts("smoke passed: ruby #{RUBY_VERSION} #{RUBY_PLATFORM} peddler #{spec.version} (#{spec.platform})")
