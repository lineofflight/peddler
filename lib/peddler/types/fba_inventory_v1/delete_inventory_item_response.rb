# frozen_string_literal: true

# This file is generated. Do not edit.

require "peddler/types/fba_inventory_v1/error"

module Peddler
  module Types
    module FBAInventoryV1
      # The response schema for the DeleteInventoryItem operation.
      DeleteInventoryItemResponse = Structure.new do
        # @return [Array<Error>] One or more unexpected errors occurred during the DeleteInventoryItem operation.
        attribute?(:errors, [Error])
      end
    end
  end
end
