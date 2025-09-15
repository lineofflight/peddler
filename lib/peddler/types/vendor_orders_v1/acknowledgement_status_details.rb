# frozen_string_literal: true

require "peddler/types/vendor_orders_v1/item_quantity"

module Peddler
  module Types
    module VendorOrdersV1
      # Details of item quantity ordered
      AcknowledgementStatusDetails = Structure.new do
        # @return [String] The date when the line item was confirmed by vendor. Must be in ISO-8601 date/time format.
        attribute(:acknowledgement_date, String, from: "acknowledgementDate")

        # @return [ItemQuantity] Item quantity accepted by vendor to be shipped.
        attribute(:accepted_quantity, ItemQuantity, from: "acceptedQuantity")

        # @return [ItemQuantity] Item quantity rejected by vendor.
        attribute(:rejected_quantity, ItemQuantity, from: "rejectedQuantity")
      end
    end
  end
end
