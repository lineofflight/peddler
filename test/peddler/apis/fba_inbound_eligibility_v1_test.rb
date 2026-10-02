# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class FBAInboundEligibilityV1Test < Minitest::Test
      include FeatureHelpers

      def test_get_item_eligibility_preview
        res = api.get_item_eligibility_preview(asin: "TEST_CASE_200", program: "INBOUND")

        assert_success(res)
      end
    end
  end
end
