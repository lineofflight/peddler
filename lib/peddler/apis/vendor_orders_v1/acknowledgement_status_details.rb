# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"
require "time"

module Peddler
  module APIs
    class VendorOrdersV1
      # Details of item quantity ordered
      AcknowledgementStatusDetails = Structure.new do
        # @return [ItemQuantity] Item quantity accepted by vendor to be shipped.
        attribute?(:accepted_quantity, ItemQuantity, from: "acceptedQuantity")

        # @return [Time] The date when the line item was confirmed by vendor. Must be in ISO-8601 date/time format.
        attribute?(:acknowledgement_date, Time, from: "acknowledgementDate")

        # @return [ItemQuantity] Item quantity rejected by vendor.
        attribute?(:rejected_quantity, ItemQuantity, from: "rejectedQuantity")
      end
    end
  end
end
