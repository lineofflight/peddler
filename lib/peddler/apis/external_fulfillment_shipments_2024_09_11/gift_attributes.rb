# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentShipments20240911
      # Information about any gift wrapping that is needed for this line item.
      GiftAttributes = Structure.new do
        # @return [String] When true, there is a gift message that must be printed on the wrapped gift.
        attribute(:gift_message_presence, String, from: "giftMessagePresence")

        # @return [String] When true, the line item must be gift wrapped.
        attribute(:gift_wrap_requirement, String, from: "giftWrapRequirement")

        # @return [Document] The gift message that is to be printed on the wrapped gift.
        attribute?(:gift_message, Document, from: "giftMessage")

        # @return [String] The label to be printed on the wrapped gift.
        attribute?(:gift_wrap_label, String, from: "giftWrapLabel")
      end
    end
  end
end
