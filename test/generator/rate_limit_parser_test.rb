# frozen_string_literal: true

require "helper"
require "generator/parsers/rate_limit_parser"

module Generator
  class RateLimitParserTest < Minitest::Test
    def test_parses_standard_rate_limit_table
      operation = {
        "operationId" => "getOrder",
        "description" => "Get order details.\n\n**Usage Plan:**\n\n| Rate (requests per second) | Burst |\n| ---- | ---- |\n| 0.0167 | 20 |",
      }

      rate_limit = RateLimitParser.new(operation).parse

      assert_in_delta(0.0167, rate_limit)
    end

    def test_parses_rate_limit_with_literal_newlines
      operation = {
        "operationId" => "getOrder",
        "description" => "Get order details.\\n\\n**Usage Plan:**\\n\\n| Rate (requests per second) | Burst |\\n| ---- | ---- |\\n| 2 | 30 |",
      }

      rate_limit = RateLimitParser.new(operation).parse

      assert_in_delta(2.0, rate_limit)
    end

    def test_parses_three_column_table
      operation = {
        "operationId" => "getOrder",
        "description" => "Get order details.\n\n**Usage Plan:**\n\n| Plan | Rate (requests per second) | Burst |\n| ---- | ---- | ---- |\n| Default | 0.5 | 10 |",
      }

      rate_limit = RateLimitParser.new(operation).parse

      assert_in_delta(0.5, rate_limit)
    end

    def test_returns_unknown_for_variable_rate_limit
      operation = {
        "operationId" => "getOrder",
        "description" => "Get order details.\n\n**Usage Plan:**\n\n| Rate (requests per second) | Burst |\n| ---- | ---- |\n| n | n |",
      }

      rate_limit = RateLimitParser.new(operation).parse

      assert_equal(:unknown, rate_limit)
    end

    def test_returns_nil_when_no_usage_plan
      operation = {
        "operationId" => "getOrder",
        "description" => "Get order details without any usage plan information.",
      }

      rate_limit = RateLimitParser.new(operation).parse

      assert_nil(rate_limit)
    end

    def test_raises_when_usage_plan_exists_but_cannot_parse
      operation = {
        "operationId" => "getOrder",
        "description" => "Get order details.\n\n**Usage Plan:**\n\nMalformed table content here",
      }

      assert_raises(RuntimeError) do
        RateLimitParser.new(operation).parse
      end
    end
  end
end
