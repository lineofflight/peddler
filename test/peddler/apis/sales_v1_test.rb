# frozen_string_literal: true

require "helper"
require "peddler/apis/sales_v1"

module Peddler
  module APIs
    class SalesV1Test < Minitest::Test
      include FeatureHelpers

      def test_get_order_metrics
        res = api.get_order_metrics(["A1805IZSGTT6HS"], "2025-05-01T00:00:00-00:00--2025-06-01T00:00:00-00:00", "Total")

        assert_predicate(res.status, :success?)
      end
    end
  end
end
