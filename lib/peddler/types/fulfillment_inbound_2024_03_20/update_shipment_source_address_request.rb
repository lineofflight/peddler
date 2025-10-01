# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/address_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `UpdateShipmentSourceAddress` request.
      UpdateShipmentSourceAddressRequest = Structure.new do
        # @return [AddressInput]
        attribute(:address, AddressInput)
      end
    end
  end
end
