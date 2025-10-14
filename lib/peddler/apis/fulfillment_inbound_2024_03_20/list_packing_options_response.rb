# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class FulfillmentInbound20240320
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
