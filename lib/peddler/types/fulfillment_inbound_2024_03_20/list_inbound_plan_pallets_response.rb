# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/pagination"
require "peddler/types/fulfillment_inbound_2024_03_20/pallet"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listInboundPlanPallets` response.
      ListInboundPlanPalletsResponse = Structure.new do
        # @return [Pagination]
        attribute(:pagination, Pagination)

        # @return [Array<Pallet>] The pallets in an inbound plan.
        attribute(:pallets, [Pallet])
      end
    end
  end
end
