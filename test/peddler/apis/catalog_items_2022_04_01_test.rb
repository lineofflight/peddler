# frozen_string_literal: true

require "helper"
require "peddler/apis/catalog_items_2022_04_01"

module Peddler
  module APIs
    class CatalogItems20220401Test < Minitest::Test
      include FeatureHelpers

      def test_search_catalog_items
        res = api.search_catalog_items(
          Marketplace.ids("UK"),
          identifiers: "188864544X",
          identifiers_type: "ASIN",
        )

        assert_predicate(res.status, :success?)
      end

      def test_get_catalog_item
        res = api.get_catalog_item(
          "188864544X",
          Marketplace.ids("UK"),
          included_data: [
            "classifications",
            "dimensions",
            "identifiers",
            "images",
            "productTypes",
            "relationships",
            "salesRanks",
            "summaries",
          ],
        )

        assert_predicate(res.status, :success?)
      end
    end
  end
end
