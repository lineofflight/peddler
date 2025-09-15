# frozen_string_literal: true

require "peddler/types/fba_inventory_v1/error"

module Peddler
  module Types
    module FBAInventoryV1
      # The response schema for the CreateInventoryItem operation.
      CreateInventoryItemResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the CreateInventoryItem operation.
        attribute(:errors, [Error])
      end
    end
  end
end
