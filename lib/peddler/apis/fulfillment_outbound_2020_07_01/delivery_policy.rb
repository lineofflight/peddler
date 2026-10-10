# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentOutbound20200701
      # The policy for a delivery offering.
      DeliveryPolicy = Structure.new do
        # Localized messaging for a delivery offering.
        attribute?(:message, DeliveryMessage)
      end
    end
  end
end
