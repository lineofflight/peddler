# frozen_string_literal: true

require "helper"
require "peddler/api"

module Peddler
  class APITest < Minitest::Test
    include Recordable

    def setup
      @api = API.new("eu-west-1", "access_token")
      # Reset configuration to default
      Peddler::Config.instance_variable_set(:@raise_on_server_errors, nil)
      super
    end

    def teardown
      # Reset configuration after each test
      Peddler::Config.instance_variable_set(:@raise_on_server_errors, nil)
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

    def test_date_header_added_per_request
      refute(@api.http.default_options.headers["X-Amz-Date"])
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

      assert_equal(initial_http_object_id, @api.meter(1.0).http.object_id)
    end

    def test_snake_case_name_with_date
      test_class = Class.new(API) do
        class << self
          def name
            "Peddler::APIs::Orders20220401"
          end
        end
      end

      assert_equal("orders_2022_04_01", test_class.snake_case_name)
    end

    def test_snake_case_name_with_version
      test_class = Class.new(API) do
        class << self
          def name
            "Peddler::APIs::InventoryV1"
          end
        end
      end

      assert_equal("inventory_v1", test_class.snake_case_name)
    end

    def test_snake_case_name_with_acronym
      test_class = Class.new(API) do
        class << self
          def name
            "Peddler::APIs::FBAOrders"
          end
        end
      end

      assert_equal("fba_orders", test_class.snake_case_name)
    end

    def test_rate_limit
      @api.meter(1.0)

      assert_kind_of(HTTP::Client, @api.http)

      @api.stub(:retries, 1) do
        @api.meter(1.0)

        assert_kind_of(HTTP::Retriable::Client, @api.http)
      end
    end

    def test_custom_rate_limit
      # http.instance_variable_get(:@performer).instance_variable_get(:@delay_calculator).instance_variable_get(:@delay)
      skip("HTTP doesn't expose retriable arguments for inspection")
    end

    def test_sandbox_rate_limit
      skip("HTTP doesn't expose retriable arguments for inspection")
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

    def test_server_errors_return_response_by_default
      # Mock HTTP client to return 500 error
      mock_http = Minitest::Mock.new
      mock_http.expect(:headers, mock_http) { |h| h.key?("X-Amz-Date") }
      mock_http.expect(
        :get,
        HTTP::Response.new(
          body: "Internal Server Error",
          headers: {},
          status: 500,
          version: nil,
          request: nil,
        ),
        [URI],
      )

      @api.stub(:http, mock_http) do
        # Should emit deprecation warning
        response = nil
        assert_output(nil, /\[DEPRECATION\]/) do
          response = @api.get("/test")
        end

        # Should return wrapped response, not raise
        assert_instance_of(Response, response)
        assert_equal(500, response.status)
      end
    end

    def test_server_errors_raise_when_configured
      Peddler.raise_on_server_errors = true

      # Mock HTTP client to return 500 error
      mock_http = Minitest::Mock.new
      mock_http.expect(:headers, mock_http) { |h| h.key?("X-Amz-Date") }
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
          @api.get("/test")
        end
      end
    ensure
      Peddler.instance_variable_set(:@raise_on_server_errors, nil)
    end

    def test_client_errors_always_raise
      # Mock HTTP client to return 404 error
      mock_http = Minitest::Mock.new
      mock_http.expect(:headers, mock_http) { |h| h.key?("X-Amz-Date") }
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
          @api.get("/test")
        end
      end
    end
  end
end
