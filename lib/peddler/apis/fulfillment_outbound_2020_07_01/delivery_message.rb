# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # Localized messaging for a delivery offering.
      DeliveryMessage = Structure.new do
        # The locale for the message (e.g., `en_US`).
        attribute?(:locale, String)

        # The message content for a delivery offering.
        attribute?(:text, String)
      end
    end
  end
end
