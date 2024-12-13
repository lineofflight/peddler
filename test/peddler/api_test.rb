# frozen_string_literal: true

require "helper"
require "peddler/api"

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
      assert_equal(200, @api.get("/").status)
    end

    def test_chainable_http_methods
      @api.use(instrumentation: { instrumenter: nil })

      refute_empty(@api.http.default_options.features)
    end

    def test_rate_limit_noop
      initial_http_object_id = @api.http.object_id
      @api.meter(1.0).http

      assert_equal(initial_http_object_id, @api.http.object_id)
    end

    def test_rate_limit
      skip("HTTP v6.0 not released yet")
    end

    def test_custom_rate_limit
      skip("HTTP v6.0 not released yet")
    end

    def test_sandbox_rate_limit
      skip("HTTP v6.0 not released yet")
    end

    def test_client_error
      assert_raises(Peddler::Error) do
        @api.post("/")
      end
    end

    def test_body_to_json_conversion
      error = assert_raises(Peddler::Error) do
        @api.post("/", body: { key: "value" })
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
  end
end
