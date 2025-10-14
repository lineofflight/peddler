# frozen_string_literal: true

# This file is generated. Do not edit.

require "structure"

module Peddler
  module APIs
    class ExternalFulfillmentInventory20240911
      # The response of the `batchInventory` operation.
      BatchInventoryResponse = Structure.new do
        # @return [Array<InventoryResponse>]
        attribute?(:responses, [InventoryResponse])
      end
    end
  end
end
