# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # Defines an item's input parameters.
      ItemInput = Structure.new do
        # @return [String]
        attribute(:label_owner, String, from: "labelOwner")

        # @return [String] The merchant SKU, a merchant-supplied identifier of a specific SKU.
        attribute(:msku, String)

        # @return [String]
        attribute(:prep_owner, String, from: "prepOwner")

        # @return [Integer] The number of units of the specified MSKU that will be shipped.
        attribute(:quantity, Integer)

        # @return [String] The expiration date of the MSKU. In [ISO
        # 8601](https://developer-docs.amazon.com/sp-api/docs/iso-8601) datetime format with pattern `YYYY-MM-DD`. Items
        # with the same MSKU but different expiration dates cannot go into the same box.
        attribute?(:expiration, String)

        # @return [String] The manufacturing lot code.
        attribute?(:manufacturing_lot_code, String, from: "manufacturingLotCode")
      end
    end
  end
end
