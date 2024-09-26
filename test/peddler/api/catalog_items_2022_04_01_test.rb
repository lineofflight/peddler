# frozen_string_literal: true

require "helper"

require "peddler/api/catalog_items_2022_04_01"

module Peddler
  class API
    class CatalogItems20220401Test < Minitest::Test
      include FeatureHelpers

      def test_search_catalog_items
        res = api.search_catalog_items(
          ["A1F83G8C2ARO7P"],
          identifiers: "188864544X",
          identifiers_type: "ASIN",
        )

        assert_predicate(res.status, :ok?)
      end
    end
  end
end
