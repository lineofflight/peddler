# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      FulfillmentReturnItem = Structure.new do
        # @return [String]
        attribute(:received_date_time, String, from: "ReceivedDateTime")

        # @return [Integer]
        attribute(:returned_quantity, Integer, from: "ReturnedQuantity")

        # @return [String]
        attribute(:seller_sku, String, from: "SellerSKU")
      end
    end
  end
end
