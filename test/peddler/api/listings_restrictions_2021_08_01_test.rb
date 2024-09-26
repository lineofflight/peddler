# frozen_string_literal: true

require "helper"

require "peddler/api/listings_restrictions_2021_08_01"

module Peddler
  class API
    class ListingsRestrictions20210801Test < Minitest::Test
      include FeatureHelpers

      def test_get_listings_restrictions
        res = api.get_listings_restrictions(
          "188864544X",
          "A34PPN1ZLYCOGT",
          "A1F83G8C2ARO7P",
          condition_type: "new_new",
        )

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
