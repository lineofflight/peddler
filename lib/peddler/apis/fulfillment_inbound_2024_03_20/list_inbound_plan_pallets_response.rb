# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
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
