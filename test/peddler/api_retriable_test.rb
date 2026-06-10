# frozen_string_literal: true

require "helper"

module Peddler
  class APIRetriableTest < Minitest::Test
    def setup
      @api = API.new("eu-west-1", "access_token", retries: 3)
      @client = @api.http(rate_limit: 2.0)
      @retriable_opts = @client.default_options.retriable
    end

    def teardown
      Thread.current[:peddler_last_retry_status] = nil
    end

    def test_http_retriable_tries
      assert_equal(@api.retries + 1, @retriable_opts[:tries])
    end

    def test_http_retriable_statuses
      assert_equal(Peddler::API::TRANSIENT_STATUSES, @retriable_opts[:retry_statuses])
    end

    def test_http_retriable_callbacks
      assert_kind_of(Proc, @retriable_opts[:delay])
      assert_kind_of(Proc, @retriable_opts[:on_retry])
    end

    def test_http_retriable_delay_for_429
      res_429 = Struct.new(:status).new(429)
      @retriable_opts[:on_retry].call(nil, nil, res_429)
      delay = @retriable_opts[:delay]

      assert_in_delta(0.5, delay.call(1), 0.1) # 0.5 * 2^0
      assert_in_delta(1.0, delay.call(2), 0.1) # 0.5 * 2^1
      assert_in_delta(2.0, delay.call(3), 0.1) # 0.5 * 2^2
    end

    def test_http_retriable_delay_for_503
      res_503 = Struct.new(:status).new(503)
      @retriable_opts[:on_retry].call(nil, nil, res_503)
      delay = @retriable_opts[:delay]

      assert_in_delta(0.0, delay.call(1), 1.1) # (2^0 - 1) + rand (0..1)
      assert_in_delta(1.0, delay.call(2), 1.1) # (2^1 - 1) + rand (1..2)
      assert_in_delta(3.0, delay.call(3), 1.1) # (2^2 - 1) + rand (3..4)
    end

    def test_http_retriable_delay_for_network_errors
      @retriable_opts[:on_retry].call(nil, StandardError.new, nil)
      delay = @retriable_opts[:delay]

      assert_in_delta(0.0, delay.call(1), 1.1)
    end
  end
end
