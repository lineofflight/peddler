# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
      # The `createInboundPlan` request.
      CreateInboundPlanRequest = Structure.new do
        # @return [Array<String>] Marketplaces where the items need to be shipped to. Currently only one marketplace can
        #   be selected in this request.
        attribute(:destination_marketplaces, [String], from: "destinationMarketplaces")

        # @return [Array<ItemInput>] Items included in this plan.
        attribute(:items, [ItemInput])

        # @return [AddressInput]
        attribute(:source_address, AddressInput, from: "sourceAddress")

        # @return [String] Name for the Inbound Plan. If one isn't provided, a default name will be provided.
        attribute?(:name, String)
      end
    end
  end
end
