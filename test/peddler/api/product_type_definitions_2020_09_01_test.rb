# frozen_string_literal: true

require "helper"

require "peddler/api/product_type_definitions_2020_09_01"

module Peddler
  class API
    class ProductTypeDefinitions20200901Test < Minitest::Test
      def setup
        super
        @api = ProductTypeDefinitions20200901.new(aws_region, request_access_token)
      end

      def test_get_definitions_product_type
        res = @api.get_definitions_product_type(
          "PRODUCT",
          "A1F83G8C2ARO7P",
          requirements: "LISTING_OFFER_ONLY",
        )

        assert_predicate(res.status, :ok?)

        # And download the JSON schema
        url = res.parse.dig("schema", "link", "resource")
        json_schema = HTTP.get(url).parse(:json)

        assert(json_schema)
      end
    end
  end
end
