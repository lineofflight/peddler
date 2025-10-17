# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ProductPricing20220501
      # The offer data of a product.
      Offer = Structure.new do
        # @return [String] Item Condition.
        attribute(:condition, String)

        # @return [String] The fulfillment type for the offer. Possible values are `AFN` (Amazon Fulfillment Network)
        #   and `MFN` (Merchant Fulfillment Network).
        attribute(:fulfillment_type, String, from: "fulfillmentType")

        # @return [Money] The offer buying price. This doesn't include shipping, points, or applicable promotions.
        attribute(:listing_price, Money, from: "listingPrice")

        # @return [String] The seller identifier for the offer.
        attribute(:seller_id, String, from: "sellerId")

        # @return [Points] The number of Amazon Points that are offered with the purchase of an item and the monetary
        #   value of these points. Note that the Points element is only returned in Japan (JP).
        attribute?(:points, Points)

        # @return [PrimeDetails] Amazon Prime details.
        attribute?(:prime_details, PrimeDetails, from: "primeDetails")

        # @return [Array<ShippingOption>] A list of shipping options associated with this offer
        attribute?(:shipping_options, [ShippingOption], from: "shippingOptions")

        # @return [String] The item subcondition of the offer.
        attribute?(:sub_condition, String, from: "subCondition")
      end
    end
  end
end
