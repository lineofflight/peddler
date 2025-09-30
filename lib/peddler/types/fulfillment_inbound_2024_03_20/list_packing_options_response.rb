# frozen_string_literal: true

# This file is generated. Edit template if necessary.

require "peddler/types/fulfillment_inbound_2024_03_20/packing_option"
require "peddler/types/fulfillment_inbound_2024_03_20/pagination"

module Peddler
  module Types
    module FulfillmentInbound20240320
      # The `listPlacementOptions` response.
      ListPackingOptionsResponse = Structure.new do
        # @return [Array<PackingOption>] List of packing options.
        attribute(:packing_options, [PackingOption], from: "packingOptions")

        # @return [Pagination]
        attribute?(:pagination, Pagination)
      end
    end
  end
end
