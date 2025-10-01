# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fulfillment_inbound_2024_03_20/pallet"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listInboundPlanPallets` response.
      ListInboundPlanPalletsResponse = Structure.new do
        # @return [Array<Pallet>] The pallets in an inbound plan.
        attribute(:pallets, [Pallet])

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
