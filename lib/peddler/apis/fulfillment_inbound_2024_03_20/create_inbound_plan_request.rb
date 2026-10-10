# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `createInboundPlan` request.
      CreateInboundPlanRequest = Structure.new do
        # Marketplaces where the items need to be shipped to. Currently only one marketplace can be selected in this
        # request.
        attribute(:destination_marketplaces, [String], null: false, from: "destinationMarketplaces")

        # Items included in this plan.
        attribute(:items, [ItemInput], null: false)

        attribute(:source_address, AddressInput, null: false, from: "sourceAddress")

        # Name for the Inbound Plan. If one isn't provided, a default name will be provided.
        attribute?(:name, String)
      end
    end
  end
end
