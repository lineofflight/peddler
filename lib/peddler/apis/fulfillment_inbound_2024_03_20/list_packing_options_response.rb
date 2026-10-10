# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    module FulfillmentInbound20240320
      # The `listPlacementOptions` response.
      ListPackingOptionsResponse = Structure.new do
        # List of packing options.
        attribute(:packing_options, [PackingOption], null: false, from: "packingOptions")

        attribute?(:pagination, Pagination)
      end
    end
  end
end
