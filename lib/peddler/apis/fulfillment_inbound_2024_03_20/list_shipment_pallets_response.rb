# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `listShipmentPallets` response.
      ListShipmentPalletsResponse = Structure.new do
        # The pallets in a shipment.
        attribute(:pallets, [Pallet], null: false)

        attribute?(:pagination, Pagination)
      end
    end
  end
end
