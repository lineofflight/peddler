# frozen_string_literal: true

require "minitest/autorun"
require "vcr"
require "webmock/minitest"

# Silence generator logger warnings during tests
require "generator/logger"
Generator.logger.level = Logger::ERROR

VCR.configure do |c|
  c.hook_into(:webmock)
  c.cassette_library_dir = "test/vcr_cassettes"

  ["client_id", "client_secret", "refresh_token"].each do |param|
    c.filter_sensitive_data("FILTERED") do |interaction|
      interaction.request.body.to_s[/(?<=#{param}=)[^&]+/]
    end
  end

  ["refresh_token", "access_token"].each do |token|
    c.filter_sensitive_data("FILTERED") do |interaction|
      JSON.parse(interaction.response.body)[token]
    rescue
      nil
    end
  end

  c.filter_sensitive_data("FILTERED") do |interaction|
    interaction.request.headers["X-Amz-Access-Token"]&.first
  end

  c.preserve_exact_body_bytes do |http_message|
    http_message.body.encoding.name == "ASCII-8BIT" ||
      !http_message.body.valid_encoding?
  end
end

module Configurable
  def aws_region
    config[:aws_region]
  end

  def client_id
    config[:client_id]
  end

  def client_secret
    config[:client_secret]
  end

  def refresh_token
    config[:refresh_token]
  end

  def config
    ["config.json", "config.example.json"].each do |path|
      file = File.join(__dir__, path)
      if File.exist?(file)
        return JSON.load_file(file, symbolize_names: true)
      end
    end
  end
end

module Recordable
  def setup
    super

    test_name = location.split(/::|#/).join("/")
    VCR.insert_cassette(test_name)
  end

  def teardown
    super

    VCR.eject_cassette
  end
end

module FeatureHelpers
  include Configurable, Recordable

  def api(grantless: false, typed: false)
    access_token = request_access_token(grantless:)
    klass = api_class
    klass = klass.typed if typed
    klass.new(aws_region, access_token)
  end

  def api_class
    Object.const_get("Peddler::APIs::#{api_name}")
  end

  def api_name
    self.class.name.split("::").last.sub(/Test$/, "")
  end

  def request_access_token(grantless:)
    require "peddler/token"

    payload = if grantless
      scope = "sellingpartnerapi::notifications"
      Peddler::Token.request(client_id: client_id, client_secret: client_secret, scope: scope)
    else
      Peddler::Token.request(client_id: client_id, client_secret: client_secret, refresh_token: refresh_token)
    end

    payload.parse["access_token"]
  end
end
