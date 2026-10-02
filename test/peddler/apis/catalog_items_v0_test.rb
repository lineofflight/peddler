# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class CatalogItemsV0Test < Minitest::Test
      include FeatureHelpers

      def test_list_catalog_categories
        res = api.list_catalog_categories(marketplace_id: "TEST_CASE_200", asin: "asin_200")

        assert_success(res)
      end
    end
  end
end
