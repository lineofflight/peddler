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

    def test_endpoint
      assert_kind_of(URI, @api.endpoint)
    end

    def test_sandbox
      assert_includes(@api.sandbox.endpoint.host, "sandbox")
    end

    def test_cannot_sandbox
      assert_raises(API::CannotSandbox) do
        @api.sandbox.cannot_sandbox!
      end
    end

    def test_must_sandbox
      assert_raises(API::MustSandbox) do
        @api.must_sandbox!
      end
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
  end
end
