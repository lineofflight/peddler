# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/pagination"
require "peddler/types/fulfillment_inbound_2024_03_20/pallet"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listShipmentPallets` response.
      ListShipmentPalletsResponse = Structure.new do
        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<Pallet>] The pallets in a shipment.
        attribute(:pallets, [Pallet])
      end
    end
  end
end
