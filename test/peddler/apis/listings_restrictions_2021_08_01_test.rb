# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class ListingsRestrictions20210801Test < Minitest::Test
      include FeatureHelpers

      def test_get_listings_restrictions
        res = api.get_listings_restrictions(
          "188864544X",
          "A34PPN1ZLYCOGT",
          Marketplace.ids("UK"),
          condition_type: "new_new",
        )

        assert_success(res)
      end
    end
  end
end
