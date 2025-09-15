# frozen_string_literal: true

require "structure"

module Peddler
  module Types
    module VendorDirectFulfillmentOrders20211228
      # Gift details for the item.
      GiftDetails = Structure.new do
        # @return [String] Gift message to be printed in shipment.
        attribute(:gift_message, String, from: "giftMessage")

        # @return [String] Gift wrap identifier for the gift wrapping, if any.
        attribute(:gift_wrap_id, String, from: "giftWrapId")
      end
    end
  end
end
