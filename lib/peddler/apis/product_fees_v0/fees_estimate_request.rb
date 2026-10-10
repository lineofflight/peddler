# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductFeesV0
      # A product, marketplace, and proposed price used to request estimated fees.
      FeesEstimateRequest = Structure.new do
        # A unique identifier provided by the caller to track this request.
        attribute(:identifier, String, null: false, from: "Identifier")

        # A marketplace identifier.
        attribute(:marketplace_id, String, null: false, from: "MarketplaceId")

        # The product price that the fee estimate is based on.
        attribute(:price_to_estimate_fees, PriceToEstimateFees, null: false, from: "PriceToEstimateFees")

        # When true, the offer is fulfilled by Amazon.
        attribute?(:amazon_fulfilled, :boolean, from: "IsAmazonFulfilled")

        attribute?(:optional_fulfillment_program, String, from: "OptionalFulfillmentProgram")
      end
    end
  end
end
