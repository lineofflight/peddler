# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentInventory20240911
      # A list of inventory requests.
      BatchInventoryRequest = Structure.new do
        # @return [Array<InventoryRequest>]
        attribute?(:requests, [InventoryRequest])
      end
    end
  end
end
