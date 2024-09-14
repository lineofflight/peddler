# frozen_string_literal: true

# Keep SimpleCov at top.
if ENV["COVERAGE"]
  require "simplecov"

  SimpleCov.start do
    add_filter "/test/"
  end
end

require "minitest/autorun"
require "vcr"

module Minitest
  class Test
    def setup
      VCR.insert_cassette(test_name)
    end

    def teardown
      VCR.eject_cassette
    end

    private

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

    def test_name
      location.split(/::|#/).join("/")
    end

    def request_access_token
      require "peddler/access_token"
      Peddler::AccessToken.new(client_id, client_secret, refresh_token: refresh_token).request
    end
  end
end

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
