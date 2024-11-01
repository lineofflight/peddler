# frozen_string_literal: true

require "helper"

require "peddler/apis/orders_v0"
require "peddler/marketplace"

module Peddler
  module APIs
    class OrdersV0Test < Minitest::Test
      include FeatureHelpers

      def test_get_orders
        res = api.sandbox.get_orders(Marketplace.ids("US"), created_after: "TEST_CASE_200")

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
