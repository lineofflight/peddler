# frozen_string_literal: true

require "minitest/autorun"
require "generator/operation"
require "generator/path"
require "tempfile"

module Generator
  class OperationRenderTest < Minitest::Test
    def setup
      @path = Generator::Path.new("/orders/{orderId}", {})
    end

    def test_renders_simple_operation
      operation_data = {
        "operationId" => "getOrder",
        "description" => "Get an order by ID",
        "parameters" => [
          { "name" => "orderId", "in" => "path", "type" => "string", "required" => true },
        ],
        "responses" => {
          "200" => {
            "description" => "Success",
          },
        },
      }
      template = <<~ERB
        def <%= method_definition %>
          <%= sandbox_rule -%>
          path = "<%= path %>"
          <%= verb %>(path)
        end
      ERB

      operation = Generator::Operation.new(@path, "get", operation_data, template: template)
      result = operation.render

      assert_includes(result, "def get_order(order_id)")
      assert_includes(result, 'path = "/orders/#{percent_encode(order_id)}"')
      assert_includes(result, "get(path)")
    end

    def test_renders_operation_with_query_params
      operation_data = {
        "operationId" => "listOrders",
        "description" => "List orders",
        "parameters" => [
          { "name" => "marketplaceIds", "in" => "query", "type" => "array", "required" => true },
          { "name" => "createdAfter", "in" => "query", "type" => "string", "required" => false },
        ],
        "responses" => {
          "200" => {
            "description" => "Success",
          },
        },
      }
      template = <<~ERB
        def <%= method_definition %>
          path = "<%= path %>"
          params = {
            <% query_params.each do |key, value| -%>
            "<%= key %>" => <%= value %>,
            <% end -%>
          }.compact
          get(path, params:)
        end
      ERB

      @path = Generator::Path.new("/orders", {})
      operation = Generator::Operation.new(@path, "get", operation_data, template: template)
      result = operation.render

      assert_includes(result, "def list_orders(marketplace_ids, created_after: nil)")
      assert_includes(result, '"marketplaceIds" => stringify_array(marketplace_ids)')
      assert_includes(result, '"createdAfter" => created_after')
    end

    def test_renders_operation_with_typed_response
      operation_data = {
        "operationId" => "getOrder",
        "description" => "Get an order",
        "parameters" => [
          { "name" => "orderId", "in" => "path", "type" => "string", "required" => true },
        ],
        "responses" => {
          "200" => {
            "schema" => {
              "$ref" => "#/definitions/GetOrderResponse",
            },
          },
        },
      }
      template = <<~ERB
        def <%= method_definition %>
          path = "<%= path %>"
          <% if has_typed_response? -%>
          parser = <%= parser_class %> if typed?
          <% end -%>
          get(path<% if has_typed_response? -%>, parser:<% end -%>)
        end
      ERB

      operation = Generator::Operation.new(@path, "get", operation_data, api_name_with_version: "orders_v0", template: template)
      result = operation.render

      assert_includes(result, "def get_order(order_id)")
      assert_includes(result, "parser = Peddler::Types::OrdersV0::GetOrderResponse if typed?")
      assert_includes(result, "get(path, parser:)")
    end

    def test_renders_operation_with_body_param
      operation_data = {
        "operationId" => "createOrder",
        "description" => "Create an order",
        "parameters" => [
          { "name" => "body", "in" => "body", "required" => true },
        ],
        "responses" => {
          "201" => {
            "description" => "Created",
          },
        },
      }
      template = <<~ERB
        def <%= method_definition %>
          path = "<%= path %>"
          <% if body_param_name -%>
          post(path, body:)
          <% else -%>
          post(path)
          <% end -%>
        end
      ERB

      operation = Generator::Operation.new(@path, "post", operation_data, template: template)
      result = operation.render

      assert_includes(result, "def create_order(body)")
      assert_includes(result, 'path = "/orders/#{percent_encode(order_id)}"')
      assert_includes(result, "post(path, body:)")
    end
  end
end
