# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `UpdateShipmentSourceAddress` request.
      UpdateShipmentSourceAddressRequest = Structure.new do
        attribute(:address, AddressInput, null: false)
      end
    end
  end
end
