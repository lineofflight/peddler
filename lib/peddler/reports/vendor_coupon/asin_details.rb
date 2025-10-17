# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Reports
    module VendorCoupon
      # Contains details about an asin.
      ASINDetails = Structure.new do
        # @return [String] Asin of the product.
        attribute(:asin, String)

        # @return [Float] Discount amount the customer receives on the product. Reflects a percentage when discountType
        #   is PERCENT_OFF_LIST_PRICE and a currency value when discountType is AMOUNT_OFF_LIST_PRICE.
        attribute(:discount_amount, Float, from: "discountAmount")

        # @return [String] Whether the discount is given as a fixed amount or a percentage off the list price.
        attribute(:discount_type, String, from: "discountType")
      end
    end
  end
end
