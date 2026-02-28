# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # Defines an item's input parameters.
      ItemInput = Structure.new do
        # @return [String]
        attribute(:label_owner, String, null: false, from: "labelOwner")

        # @return [String] The merchant SKU, a merchant-supplied identifier of a specific SKU.
        attribute(:msku, String, null: false)

        # @return [String]
        attribute(:prep_owner, String, null: false, from: "prepOwner")

        # @return [Integer] The number of units of the specified MSKU that will be shipped.
        attribute(:quantity, Integer, null: false)

        # @return [String] The expiration date of the MSKU. In [ISO
        #   8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern `YYYY-MM-DD`.
        #   Items with the same MSKU but different expiration dates cannot go into the same box.
        attribute?(:expiration, String)

        # @return [String] The manufacturing lot code.
        attribute?(:manufacturing_lot_code, String, from: "manufacturingLotCode")
      end
    end
  end
end
