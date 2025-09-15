# frozen_string_literal: true

require "peddler/types/fulfillment_inbound_2024_03_20/item_input"
require "peddler/types/fulfillment_inbound_2024_03_20/address_input"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `createInboundPlan` request.
      CreateInboundPlanRequest = Structure.new do
        # @return [Array<String>] Marketplaces where the items need to be shipped to. Currently only one marketplace can
        # be selected in this request.
        attribute(:destination_marketplaces, [String], from: "destinationMarketplaces")

        # @return [Array<ItemInput>] Items included in this plan.
        attribute(:items, [ItemInput])

        # @return [String] Name for the Inbound Plan. If one isn't provided, a default name will be provided.
        attribute(:name, String)

        # @return [AddressInput]
        attribute(:source_address, AddressInput, from: "sourceAddress")
      end
    end
  end
end
