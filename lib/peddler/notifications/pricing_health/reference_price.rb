# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module PricingHealth
      # A set of reference prices for the given ASIN
      ReferencePrice = Structure.new do
        attribute?(:average_selling_price, Money, from: "averageSellingPrice")

        attribute?(:competitive_price_threshold, Money, from: "competitivePriceThreshold")

        attribute?(:msrp_price, Money, from: "msrpPrice")

        attribute?(:retail_offer_price, Money, from: "retailOfferPrice")
      end
    end
  end
end
