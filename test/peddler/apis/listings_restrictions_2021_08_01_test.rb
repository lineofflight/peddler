# frozen_string_literal: true

require "helper"

require "peddler/apis/listings_restrictions_2021_08_01"

module Peddler
  module APIs
    class ListingsRestrictions20210801Test < Minitest::Test
      include FeatureHelpers

      def test_get_listings_restrictions
        res = api.get_listings_restrictions(
          "188864544X",
          "A34PPN1ZLYCOGT",
          Marketplace.id("UK"),
          condition_type: "new_new",
        )

        assert_predicate(res.status, :success?)
      end
    end
  end
end
