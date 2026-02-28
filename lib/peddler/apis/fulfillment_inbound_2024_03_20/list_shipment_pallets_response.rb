# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `listShipmentPallets` response.
      ListShipmentPalletsResponse = Structure.new do
        # @return [Array<Pallet>] The pallets in a shipment.
        attribute(:pallets, [Pallet], null: false)

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
