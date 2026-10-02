# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class SalesV1Test < Minitest::Test
      include FeatureHelpers

      def test_get_order_metrics
        res = api.get_order_metrics(marketplace_ids: ["A1805IZSGTT6HS"], interval: "2025-05-01T00:00:00-00:00--2025-06-01T00:00:00-00:00", granularity: "Total")

        assert_success(res)
      end
    end
  end
end
