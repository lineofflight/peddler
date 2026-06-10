# frozen_string_literal: true

require "helper"

module Peddler
  class APIRetriableTest < Minitest::Test
    def setup
      @api = API.new("eu-west-1", "access_token", retries: 3)
      @client = @api.http(rate_limit: 2.0)
      if @client.default_options.respond_to?(:retriable)
        retriable_opts = @client.default_options.retriable
        @tries = retriable_opts[:tries]
        @retry_statuses = retriable_opts[:retry_statuses]
        @delay = retriable_opts[:delay]
        @on_retry = retriable_opts[:on_retry]
      else
        performer = @client.instance_variable_get(:@performer)
        @tries = performer.instance_variable_get(:@tries)
        @retry_statuses = performer.instance_variable_get(:@retry_statuses)
        @on_retry = performer.instance_variable_get(:@on_retry)
        delay_calc = performer.instance_variable_get(:@delay_calculator)
        @delay = delay_calc.instance_variable_get(:@delay_proc)
      end
    end

    def teardown
      Thread.current[:peddler_last_retry_status] = nil
    end

    def test_http_retriable_tries
      assert_equal(@api.retries + 1, @tries)
    end

    def test_http_retriable_statuses
      assert_equal(Peddler::API::TRANSIENT_STATUSES, @retry_statuses)
    end

    def test_http_retriable_callbacks
      assert_kind_of(Proc, @delay)
      assert_kind_of(Proc, @on_retry)
    end

    def test_http_retriable_delay_for_429
      res_429 = Struct.new(:status).new(429)
      @on_retry.call(nil, nil, res_429)

      assert_in_delta(0.5, @delay.call(1), 0.1) # 0.5 * 2^0
      assert_in_delta(1.0, @delay.call(2), 0.1) # 0.5 * 2^1
      assert_in_delta(2.0, @delay.call(3), 0.1) # 0.5 * 2^2
    end

    def test_http_retriable_delay_for_503
      res_503 = Struct.new(:status).new(503)
      @on_retry.call(nil, nil, res_503)

      assert_in_delta(0.0, @delay.call(1), 1.1) # (2^0 - 1) + rand (0..1)
      assert_in_delta(1.0, @delay.call(2), 1.1) # (2^1 - 1) + rand (1..2)
      assert_in_delta(3.0, @delay.call(3), 1.1) # (2^2 - 1) + rand (3..4)
    end

    def test_http_retriable_delay_for_network_errors
      @on_retry.call(nil, StandardError.new, nil)

      assert_in_delta(0.0, @delay.call(1), 1.1)
    end
  end
end
