# frozen_string_literal: true

require "helper"

require "peddler/apis/product_type_definitions_2020_09_01"

module Peddler
  module APIs
    class ProductTypeDefinitions20200901Test < Minitest::Test
      include FeatureHelpers

      def test_get_definitions_product_type
        res = api.get_definitions_product_type(
          "PRODUCT",
          Marketplace.id("UK"),
          requirements: "LISTING_OFFER_ONLY",
        )

        assert_predicate(res.status, :success?)

        # And download the JSON schema
        url = res.dig("schema", "link", "resource")
        json_schema = HTTP.get(url).parse(:json)

        assert(json_schema)
      end
    end
  end
end
