# frozen_string_literal: true

require "helper"

module Peddler
  class APITest < Minitest::Test
    include Recordable

    def setup
      @api = API.new("eu-west-1", "access_token")
      super
    end

    def test_endpoint_uri
      assert_kind_of(URI::HTTPS, @api.endpoint_uri)
    end

    def test_sandbox
      assert_includes(@api.sandbox.endpoint_uri.host, "sandbox")
    end

    def test_base_url_overrides_endpoint_uri
      api = API.new("eu-west-1", "access_token", base_url: "http://localhost:9001")

      assert_equal("http://localhost:9001", api.endpoint_uri.to_s)
    end

    def test_base_url_accepts_https
      api = API.new("eu-west-1", "access_token", base_url: "https://example.test")

      assert_equal("https://example.test", api.endpoint_uri.to_s)
    end

    def test_base_url_does_not_mutate_across_calls
      api = API.new("eu-west-1", "access_token", base_url: "http://localhost:9001")
      api.endpoint_uri.path = "/mutated"

      assert_equal("", api.endpoint_uri.path)
    end

    def test_base_url_reader
      api = API.new("eu-west-1", "access_token", base_url: "http://localhost:9001")

      assert_kind_of(URI::HTTP, api.base_url)
    end

    def test_base_url_rejects_url_without_scheme
      assert_raises(ArgumentError) do
        API.new("eu-west-1", "access_token", base_url: "localhost:9001")
      end
    end

    def test_base_url_rejects_garbage
      assert_raises(ArgumentError) do
        API.new("eu-west-1", "access_token", base_url: "not a url")
      end
    end

    def test_base_url_rejects_url_without_host
      assert_raises(ArgumentError) do
        API.new("eu-west-1", "access_token", base_url: "http://")
      end
    end

    def test_nil_base_url_uses_production
      assert_nil(@api.base_url)
      assert_kind_of(URI::HTTPS, @api.endpoint_uri)
    end

    def test_host_header
      assert(@api.http.default_options.headers["Host"])
    end

    def test_user_agent_header
      assert_includes(@api.http.default_options.headers["User-Agent"], "Peddler")
    end

    def test_access_token_header
      assert_equal(@api.http.default_options.headers["X-Amz-Access-Token"], @api.access_token)
    end

    def test_date_header
      assert(@api.http.default_options.headers["X-Amz-Date"])
    end

    def test_http_verb_methods
      assert_equal(200, @api.send(:get, "/").status)
    end

    def test_http_with_custom_client
      custom_http = HTTP.use(instrumentation: { instrumenter: nil })
      api = API.new("eu-west-1", "access_token", http: custom_http)

      refute_empty(api.http.default_options.features)
    end

    def test_client_error
      assert_raises(Peddler::Error) do
        @api.send(:post, "/")
      end
    end

    def test_body_to_json_conversion
      error = assert_raises(Peddler::Error) do
        @api.send(:post, "/", body: { key: "value" })
      end
      request = error.response.request
      request_body = request.body.source
      request_content_type = request.headers["Content-Type"]

      assert_equal({ key: "value" }.to_json, request_body)
      assert_match(%r{\Aapplication/json}, request_content_type)
    end

    def test_cannot_sandbox!
      test_api_class = Class.new(API) do
        def perform_cannot_sandbox_operation
          cannot_sandbox!
        end
      end

      test_api = test_api_class.new("eu-west-1", "access_token")
      test_api.perform_cannot_sandbox_operation

      assert_raises(API::CannotSandbox) do
        test_api.sandbox.perform_cannot_sandbox_operation
      end
    end

    def test_must_sandbox!
      test_api_class = Class.new(API) do
        def perform_must_sandbox_operation
          must_sandbox!
        end
      end

      test_api = test_api_class.new("eu-west-1", "access_token")

      assert_raises(API::MustSandbox) do
        test_api.perform_must_sandbox_operation
      end
    end

    def test_server_errors_always_raise
      # Mock HTTP client to return 500 error
      mock_http = Minitest::Mock.new
      mock_http.expect(
        :get,
        HTTP::Response.new(
          body: JSON.dump({ "errors" => [{ "code" => "InternalError", "message" => "Server error" }] }),
          headers: { "Content-Type" => "application/json" },
          status: 500,
          version: nil,
          request: nil,
        ),
        [URI],
      )

      @api.stub(:http, mock_http) do
        assert_raises(Peddler::Error) do
          @api.send(:get, "/test")
        end
      end
    end

    def test_client_errors_always_raise
      # Mock HTTP client to return 404 error
      mock_http = Minitest::Mock.new
      mock_http.expect(
        :get,
        HTTP::Response.new(
          body: JSON.dump({ "errors" => [{ "code" => "NotFound", "message" => "Not found" }] }),
          headers: { "Content-Type" => "application/json" },
          status: 404,
          version: nil,
          request: nil,
        ),
        [URI],
      )

      @api.stub(:http, mock_http) do
        assert_raises(Peddler::Errors::NotFound) do
          @api.send(:get, "/test")
        end
      end
    end
  end
end
