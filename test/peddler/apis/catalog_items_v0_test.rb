# frozen_string_literal: true

require "helper"

module Peddler
  module APIs
    class CatalogItemsV0Test < Minitest::Test
      include FeatureHelpers

      def test_list_catalog_categories
        res = api.sandbox.list_catalog_categories("TEST_CASE_200", asin: "asin_200")

        assert_predicate(res.status, :success?)
      end
    end
  end
end
