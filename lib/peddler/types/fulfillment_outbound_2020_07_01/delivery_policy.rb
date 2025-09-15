# frozen_string_literal: true

require "peddler/types/fulfillment_outbound_2020_07_01/delivery_message"

module Peddler
  module Types
    module FulfillmentOutbound20200701
      # The policy for a delivery offering.
      DeliveryPolicy = Structure.new do
        # @return [DeliveryMessage] Localized messaging for a delivery offering.
        attribute(:message, DeliveryMessage)
      end
    end
  end
end
