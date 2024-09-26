# frozen_string_literal: true

require "helper"

require "peddler/api/orders_v0"

module Peddler
  class API
    class OrdersV0Test < Minitest::Test
      include FeatureHelpers

      def test_get_orders
        res = api.sandbox.get_orders(["ATVPDKIKX0DER"], created_after: "TEST_CASE_200")

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
