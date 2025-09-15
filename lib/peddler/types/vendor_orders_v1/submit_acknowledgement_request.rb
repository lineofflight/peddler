# frozen_string_literal: true

require "peddler/types/vendor_orders_v1/order_acknowledgement"

module Peddler
  module Types
    module VendorOrdersV1
      # The request schema for the submitAcknowledgment operation.
      SubmitAcknowledgementRequest = Structure.new do
        # @return [Array<OrderAcknowledgement>] An array of order acknowledgements to be submitted.
        attribute(:acknowledgements, [OrderAcknowledgement])
      end
    end
  end
end
