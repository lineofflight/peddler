# frozen_string_literal: true

require "peddler/types/product_fees_v0/price_to_estimate_fees"

module Peddler
  module Types
    module ProductFeesV0
      # An item identifier, marketplace, time of request, and other details that identify an estimate.
      FeesEstimateIdentifier = Structure.new do
        # @return [String] A marketplace identifier.
        attribute(:marketplace_id, String, from: "MarketplaceId")

        # @return [String] The seller identifier.
        attribute(:seller_id, String, from: "SellerId")

        # @return [String]
        attribute(:id_type, String, from: "IdType")

        # @return [String] The item identifier.
        attribute(:id_value, String, from: "IdValue")

        # @return [:boolean] When true, the offer is fulfilled by Amazon.
        attribute(:amazon_fulfilled, :boolean, from: "IsAmazonFulfilled")

        # @return [PriceToEstimateFees] The item price on which the fee estimate is based.
        attribute(:price_to_estimate_fees, PriceToEstimateFees, from: "PriceToEstimateFees")

        # @return [String] A unique identifier provided by the caller to track this request.
        attribute(:seller_input_identifier, String, from: "SellerInputIdentifier")

        # @return [String]
        attribute(:optional_fulfillment_program, String, from: "OptionalFulfillmentProgram")
      end
    end
  end
end
