# frozen_string_literal: true

require "helper"
require "peddler/apis/product_pricing_v0"
require "peddler/apis/sales_v1"

module Peddler
  module SmokeTest
    class ProductPricingV0Test < Minitest::Test
      include FeatureHelpers

      def test_money_coercion
        data = api.typed.sandbox.get_pricing("ATVPDKIKX0DER", "Asin", asins: ["B00V5DG6IQ"]).parse
        price = data.payload.first
        offer = price.product.offers.first

        assert_kind_of(::Money, offer.regular_price)
        assert_equal(1000, offer.regular_price.cents)
        assert_equal("USD", offer.regular_price.currency.iso_code)
      end
    end
  end
end
