# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Information associated with a single SKU in the seller's catalog.
      Item = Structure.new do
        # @return [String] The Amazon Standard Identification Number (ASIN) of the item.
        attribute(:asin, String, null: false)

        # @return [String] A unique identifier assigned by Amazon to products stored in and fulfilled from an Amazon
        #   fulfillment center.
        attribute(:fnsku, String, null: false)

        # @return [String] Specifies who will label the items. Options include `AMAZON`, `SELLER`, and `NONE`. `AMAZON`
        #   is not an accepted value in the US marketplace.
        attribute(:label_owner, String, null: false, from: "labelOwner")

        # @return [String] The merchant-defined SKU ID.
        attribute(:msku, String, null: false)

        # @return [Array<PrepInstruction>] Special preparations that are required for an item.
        attribute(:prep_instructions, [PrepInstruction], null: false, from: "prepInstructions")

        # @return [Integer] The number of the specified MSKU.
        attribute(:quantity, Integer, null: false)

        # @return [String] The expiration date of the MSKU. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern`YYYY-MM-DD`. The
        #   same MSKU with different expiration dates cannot go into the same box.
        attribute?(:expiration, String)

        # @return [String] The manufacturing lot code.
        attribute?(:manufacturing_lot_code, String, from: "manufacturingLotCode")
      end
    end
  end
end
