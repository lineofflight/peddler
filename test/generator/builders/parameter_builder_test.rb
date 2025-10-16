# frozen_string_literal: true

require "helper"
require "generator/builders/parameter_builder"

module Generator
  class ParameterBuilderTest < Minitest::Test
    def test_basic_parameter_names
      operation = {
        "parameters" => [
          { "name" => "id", "in" => "path", "required" => true, "type" => "string" },
          { "name" => "limit", "in" => "query", "required" => false, "type" => "integer" },
        ],
      }
      shared_parameters = []
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      assert_equal(2, params.size)
      assert_equal("id", params[0]["name"])
      assert_equal("limit", params[1]["name"])
    end

    def test_basic_parameter_requirements
      operation = {
        "parameters" => [
          { "name" => "id", "in" => "path", "required" => true, "type" => "string" },
          { "name" => "limit", "in" => "query", "required" => false, "type" => "integer" },
        ],
      }
      shared_parameters = []
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      assert(params[0]["required"])
      refute(params[1]["required"])
    end

    def test_shared_parameters
      operation = {
        "parameters" => [
          { "name" => "id", "in" => "path", "required" => true, "type" => "string" },
        ],
      }
      shared_parameters = [
        { "name" => "marketplace_id", "in" => "query", "required" => true, "type" => "string" },
      ]
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      assert_equal(2, params.size)
      assert_equal("marketplace_id", params[0]["name"])
      assert_equal("id", params[1]["name"])
    end

    def test_deduplicate_parameters
      operation = {
        "parameters" => [
          { "name" => "id", "in" => "path", "required" => true, "type" => "string" },
        ],
      }
      shared_parameters = [
        { "name" => "id", "in" => "path", "required" => true, "type" => "string" },
      ]
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      # Should deduplicate based on name
      assert_equal(1, params.size)
      assert_equal("id", params[0]["name"])
    end

    def test_rate_limit_parameter_exists
      operation = { "parameters" => [] }
      shared_parameters = []
      rate_limit = 0.5

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      rate_limit_param = params.find { |p| p["name"] == "rate_limit" }

      assert(rate_limit_param)
    end

    def test_rate_limit_parameter_properties
      operation = { "parameters" => [] }
      shared_parameters = []
      rate_limit = 0.5

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      rate_limit_param = params.find { |p| p["name"] == "rate_limit" }

      assert_equal("Float", rate_limit_param["type"])
      refute(rate_limit_param["required"])
      assert_equal("Requests per second", rate_limit_param["description"])
    end

    def test_rate_limit_parameter_default_value
      operation = { "parameters" => [] }
      shared_parameters = []
      rate_limit = 0.5

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      rate_limit_param = params.find { |p| p["name"] == "rate_limit" }

      assert_in_delta(0.5, rate_limit_param["default"])
    end

    def test_rate_limit_with_unknown_value_exists
      operation = { "parameters" => [] }
      shared_parameters = []
      rate_limit = :unknown

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      rate_limit_param = params.find { |p| p["name"] == "rate_limit" }

      assert(rate_limit_param)
    end

    def test_rate_limit_with_unknown_value_properties
      operation = { "parameters" => [] }
      shared_parameters = []
      rate_limit = :unknown

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      rate_limit_param = params.find { |p| p["name"] == "rate_limit" }

      assert_equal("Float", rate_limit_param["type"])
      refute(rate_limit_param["required"])
      assert_equal("Requests per second", rate_limit_param["description"])
    end

    def test_rate_limit_with_unknown_value_no_default
      operation = { "parameters" => [] }
      shared_parameters = []
      rate_limit = :unknown

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      rate_limit_param = params.find { |p| p["name"] == "rate_limit" }

      refute(rate_limit_param.key?("default")) # Should not have default for :unknown
    end

    def test_no_rate_limit_parameter_when_nil
      operation = { "parameters" => [] }
      shared_parameters = []
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      rate_limit_param = params.find { |p| p["name"] == "rate_limit" }

      refute(rate_limit_param)
    end

    def test_notification_type_parameter_added
      operation = {
        "parameters" => [
          { "$ref" => "#/parameters/NotificationType" }, # No name property
          { "name" => "destination_id", "in" => "path", "required" => true, "type" => "string" },
        ],
      }
      shared_parameters = []
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      # Should add notification_type parameter
      notification_param = params.find { |p| p["name"] == "notification_type" }

      assert(notification_param)
    end

    def test_notification_type_parameter_properties
      operation = {
        "parameters" => [
          { "$ref" => "#/parameters/NotificationType" }, # No name property
          { "name" => "destination_id", "in" => "path", "required" => true, "type" => "string" },
        ],
      }
      shared_parameters = []
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      notification_param = params.find { |p| p["name"] == "notification_type" }

      assert_equal("string", notification_param["type"])
      assert(notification_param["required"])
      assert_match(/Notification Type Values/, notification_param["description"])
    end

    def test_no_notification_type_when_ref_has_name
      operation = {
        "parameters" => [
          { "$ref" => "#/parameters/SomeParam", "name" => "some_param" }, # Has name property
        ],
      }
      shared_parameters = []
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      # Should not add notification_type parameter
      notification_param = params.find { |p| p["name"] == "notification_type" }

      refute(notification_param)
    end

    def test_parameter_order_shared_first
      operation = {
        "parameters" => [
          { "$ref" => "#/parameters/NotificationType" },
          { "name" => "id", "in" => "path", "required" => true, "type" => "string" },
        ],
      }
      shared_parameters = [
        { "name" => "marketplace_id", "in" => "query", "required" => true, "type" => "string" },
      ]
      rate_limit = 1.0

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      # Shared parameter should be first
      assert_equal("marketplace_id", params[0]["name"])
    end

    def test_parameter_order_rate_limit_last
      operation = {
        "parameters" => [
          { "$ref" => "#/parameters/NotificationType" },
          { "name" => "id", "in" => "path", "required" => true, "type" => "string" },
        ],
      }
      shared_parameters = [
        { "name" => "marketplace_id", "in" => "query", "required" => true, "type" => "string" },
      ]
      rate_limit = 1.0

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      # Rate limit should be last
      assert_equal("rate_limit", params.last["name"])
    end

    def test_empty_operation_with_empty_shared
      operation = { "parameters" => [] }
      shared_parameters = []
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      assert_empty(params)
    end

    def test_filters_out_parameters_without_names
      operation = {
        "parameters" => [
          { "name" => "valid", "in" => "query", "type" => "string" },
          { "in" => "query", "type" => "string" }, # Missing name
          {}, # Empty parameter
        ],
      }
      shared_parameters = []
      rate_limit = nil

      builder = ParameterBuilder.new(operation, shared_parameters, rate_limit)
      params = builder.build

      # Should only include parameter with name
      assert_equal(1, params.size)
      assert_equal("valid", params[0]["name"])
    end
  end
end
