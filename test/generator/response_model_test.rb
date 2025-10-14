# frozen_string_literal: true

require "helper"
require "generator/builders/response_model"

module Generator
  class ResponseModelTest < Minitest::Test
    def test_ref_response_model
      operation = {
        "responses" => {
          "200" => {
            "schema" => {
              "$ref" => "#/definitions/GetOrderResponse",
            },
          },
        },
      }

      model = ResponseModel.new(operation).build

      assert_equal(:response, model[:type])
      assert_equal("GetOrderResponse", model[:model])
      assert_empty(model[:path])
    end

    def test_inline_payload_with_ref
      operation = {
        "responses" => {
          "200" => {
            "schema" => {
              "properties" => {
                "payload" => {
                  "$ref" => "#/definitions/Order",
                },
              },
            },
          },
        },
      }

      model = ResponseModel.new(operation).build

      assert_equal(:single, model[:type])
      assert_equal("Order", model[:model])
      assert_equal(["payload"], model[:path])
    end

    def test_inline_payload_with_array_property
      operation = {
        "responses" => {
          "200" => {
            "schema" => {
              "properties" => {
                "payload" => {
                  "properties" => {
                    "orders" => {
                      "type" => "array",
                    },
                  },
                },
              },
            },
          },
        },
      }

      model = ResponseModel.new(operation).build

      assert_equal(:array, model[:type])
      assert_equal("order", model[:model])
      assert_equal(["payload", "orders"], model[:path])
    end

    def test_no_schema_response
      operation = {
        "responses" => {
          "204" => {},
        },
      }

      model = ResponseModel.new(operation).build

      assert_equal(:raw, model[:type])
      assert_nil(model[:model])
      assert_equal(["payload"], model[:path])
    end

    def test_handles_multiple_success_codes
      operation = {
        "responses" => {
          "201" => {
            "schema" => {
              "$ref" => "#/definitions/CreateOrderResponse",
            },
          },
        },
      }

      model = ResponseModel.new(operation).build

      assert_equal(:response, model[:type])
      assert_equal("CreateOrderResponse", model[:model])
    end
  end
end
