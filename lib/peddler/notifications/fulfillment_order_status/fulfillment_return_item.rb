# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module Notifications
    module FulfillmentOrderStatus
      FulfillmentReturnItem = Structure.new do
        # @return [String]
        attribute(:received_date_time, String, null: false, from: "ReceivedDateTime")

        # @return [Integer]
        attribute(:returned_quantity, Integer, null: false, from: "ReturnedQuantity")

        # @return [String]
        attribute(:seller_sku, String, null: false, from: "SellerSKU")
      end
    end
  end
end
