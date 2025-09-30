# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "structure"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # Localized messaging for a delivery offering.
      DeliveryMessage = Structure.new do
        # @return [String] The message content for a delivery offering.
        attribute?(:text, String)

        # @return [String] The locale for the message (e.g., `en_US`).
        attribute?(:locale, String)
      end
    end
  end
end
