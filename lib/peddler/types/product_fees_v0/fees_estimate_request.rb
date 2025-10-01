# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/product_fees_v0/price_to_estimate_fees"

module Peddler
  module Types
    module ProductFeesV0
      # A product, marketplace, and proposed price used to request estimated fees.
      FeesEstimateRequest = Structure.new do
        # @return [String] A unique identifier provided by the caller to track this request.
        attribute(:identifier, String, from: "Identifier")

        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [PriceToEstimateFees] The product price that the fee estimate is based on.
        attribute(:price_to_estimate_fees, PriceToEstimateFees, from: "PriceToEstimateFees")

        # @return [:boolean] When true, the offer is fulfilled by Amazon.
        attribute?(:amazon_fulfilled, :boolean, from: "IsAmazonFulfilled")

        # @return [String]
        attribute?(:optional_fulfillment_program, String, from: "OptionalFulfillmentProgram")
      end
    end
  end
end
