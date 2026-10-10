# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ProductFeesV0
      # An item identifier, marketplace, time of request, and other details that identify an estimate.
      FeesEstimateIdentifier = Structure.new do
        attribute?(:id_type, String, from: "IdType")

        # The item identifier.
        attribute?(:id_value, String, from: "IdValue")

        # When true, the offer is fulfilled by Amazon.
        attribute?(:amazon_fulfilled, :boolean, from: "IsAmazonFulfilled")

        # A marketplace identifier.
        attribute?(:marketplace_id, String, from: "MarketplaceId")

        attribute?(:optional_fulfillment_program, String, from: "OptionalFulfillmentProgram")

        # The item price on which the fee estimate is based.
        attribute?(:price_to_estimate_fees, PriceToEstimateFees, from: "PriceToEstimateFees")

        # The seller identifier.
        attribute?(:seller_id, String, from: "SellerId")

        # A unique identifier provided by the caller to track this request.
        attribute?(:seller_input_identifier, String, from: "SellerInputIdentifier")
      end
    end
  end
end
