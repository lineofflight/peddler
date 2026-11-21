# frozen_string_literal: true

require "base64"
require "fileutils"
require "json"
require "optparse"
require "uri"
require "yaml"

# Deliberately select only audited, non-document API interactions.
module NativeFixtures
  ROOT = File.expand_path("..", __dir__)
  SOURCES = {
    "catalog_get.json" => "test/vcr_cassettes/Peddler/APIs/CatalogItems20220401Test/test_get_catalog_item.yml",
    "listings_patch.json" => "test/vcr_cassettes/Peddler/APIs/ListingsItems20210801Test/test_patch_listings_item.yml",
    "not_found.json" => "test/vcr_cassettes/Peddler/Errors/NotFoundTest/test_not_found.yml",
  }.freeze
  RESPONSE_HEADERS = ["content-type", "x-amzn-requestid", "x-amzn-ratelimit-limit"].freeze

  class << self
    def body_bytes(body)
      body.key?("base64_string") ? Base64.strict_decode64(body.fetch("base64_string").delete("\n\r")) : body.fetch("string").b
    end

    def render(source)
      interactions = YAML.safe_load_file(File.join(ROOT, source)).fetch("http_interactions")
      selected = interactions.reject { |entry| URI(entry.fetch("request").fetch("uri")).path == "/auth/o2/token" }
      raise "Expected one SP-API interaction in #{source}" unless selected.length == 1

      request = selected.first.fetch("request")
      response = selected.first.fetch("response")
      uri = URI(request.fetch("uri"))
      bytes = body_bytes(request.fetch("body"))
      headers = response.fetch("headers").flat_map do |name, values|
        RESPONSE_HEADERS.include?(name.downcase) ? values.map { |value| [name.downcase, value] } : []
      end
      JSON.pretty_generate({
        source: source,
        request: {
          method: request.fetch("method").upcase,
          path: uri.path,
          query: URI.decode_www_form(uri.query || ""),
          body_base64: bytes.empty? ? nil : Base64.strict_encode64(bytes),
        },
        response: {
          status: response.fetch("status").fetch("code"),
          headers: headers,
          body_base64: Base64.strict_encode64(body_bytes(response.fetch("body"))),
        },
      }) + "\n"
    end

    def run(arguments)
      check = false
      output = File.join(ROOT, "test/fixtures/native")
      OptionParser.new do |options|
        options.on("--check", "Check committed fixtures without writing") { check = true }
        options.on("--output DIRECTORY", "Override output directory") { |directory| output = directory }
      end.parse!(arguments)
      raise OptionParser::InvalidArgument, arguments.join(" ") unless arguments.empty?

      FileUtils.mkdir_p(output) unless check
      drift = SOURCES.filter_map do |name, source|
        path = File.join(output, name)
        content = render(source)
        if check
          name unless File.file?(path) && File.binread(path) == content
        else
          File.binwrite(path, content)
          nil
        end
      end
      warn("Native fixtures differ: #{drift.join(', ')}") unless drift.empty?
      drift.empty? ? 0 : 1
    end
  end
end

exit(NativeFixtures.run(ARGV)) if $PROGRAM_NAME == __FILE__
