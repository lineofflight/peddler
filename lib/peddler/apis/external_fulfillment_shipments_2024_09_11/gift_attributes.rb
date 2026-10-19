# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module ExternalFulfillmentShipments20240911
      # Information about any gift wrapping that is needed for this line item.
      GiftAttributes = Structure.new do
        # When true, there is a gift message that must be printed on the wrapped gift. Known values: `ABSENT`,
        # `PRESENT`.
        attribute(:gift_message_presence, String, null: false, from: "giftMessagePresence")

        # When true, the line item must be gift wrapped. Known values: `REQUIRED`, `DISALLOWED`.
        attribute(:gift_wrap_requirement, String, null: false, from: "giftWrapRequirement")

        # The gift message that is to be printed on the wrapped gift.
        attribute?(:gift_message, Document, from: "giftMessage")

        # The label to be printed on the wrapped gift.
        attribute?(:gift_wrap_label, String, from: "giftWrapLabel")
      end
    end
  end
end
