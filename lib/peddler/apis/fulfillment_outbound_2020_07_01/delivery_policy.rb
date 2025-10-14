# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentOutbound20200701
      # The policy for a delivery offering.
      DeliveryPolicy = Structure.new do
        # @return [DeliveryMessage] Localized messaging for a delivery offering.
        attribute?(:message, DeliveryMessage)
      end
    end
  end
end
