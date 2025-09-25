# frozen_string_literal: true

require "helper"
require "peddler/types/orders_v0"

module Peddler
  module Types
    class OrdersV0Test < Minitest::Test
      def test_order_boolean_predicates
        data = {
          "AmazonOrderId" => "123",
          "IsPrime" => true,
          "IsBusinessOrder" => false,
          "IsReplacementOrder" => false,
        }
        order = OrdersV0::Order.parse(data)

        assert_predicate(order, :prime?)
        refute_predicate(order, :business_order?)
        refute_predicate(order, :replacement_order?)
      end

      def test_order_money_type
        data = {
          "AmazonOrderId" => "123",
          "OrderTotal" => {
            "CurrencyCode" => "USD",
            "Amount" => "99.99",
          },
        }
        order = OrdersV0::Order.parse(data)

        assert_instance_of(Peddler::Types::Money, order.order_total)
        assert_equal("99.99", order.order_total.amount)
        assert_equal("USD", order.order_total.currency_code)
      end

      def test_order_optional_attributes_nil
        data = { "AmazonOrderId" => "123" }
        order = OrdersV0::Order.parse(data)

        assert_nil(order.seller_order_id)
        assert_nil(order.order_total)
        assert_nil(order.ship_service_level)
      end

      def test_address_optional_fields
        data = {
          "Name" => "John Doe",
          "AddressLine1" => "123 Main St",
          "City" => "Seattle",
        }
        address = OrdersV0::Address.parse(data)

        assert_equal("John Doe", address.name)
        assert_nil(address.address_line3)
        assert_nil(address.municipality)
      end

      def test_get_orders_response_array_structure
        data = {
          "payload" => {
            "Orders" => [
              { "AmazonOrderId" => "123" },
              { "AmazonOrderId" => "456" },
            ],
            "NextToken" => "token123",
          },
        }
        response = OrdersV0::GetOrdersResponse.parse(data)

        assert_instance_of(OrdersV0::OrdersList, response.payload)
        assert_equal(2, response.payload.orders.length)
        assert_instance_of(OrdersV0::Order, response.payload.orders.first)
      end

      def test_error_response_structure
        data = {
          "errors" => [
            {
              "code" => "InvalidInput",
              "message" => "Invalid marketplace ID",
              "details" => "The marketplace ID provided is not valid",
            },
          ],
        }
        response = OrdersV0::GetOrdersResponse.parse(data)

        assert_nil(response.payload)
        assert_equal(1, response.errors.length)
        assert_instance_of(OrdersV0::Error, response.errors.first)
      end
    end
  end
end
